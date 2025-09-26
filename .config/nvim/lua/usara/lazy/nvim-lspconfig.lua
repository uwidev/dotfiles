return { -- LSP Configuration & Plugins
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
		'williamboman/mason-lspconfig.nvim',
		'WhoIsSethDaniel/mason-tool-installer.nvim',

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{ 'j-hui/fidget.nvim', opts = {} },

		-- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		-- { 'folke/neodev.nvim', opts = {} },
	},
	config = function()
		-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
		-- and elegantly composed help section, `:help lsp-vs-treesitter`

		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
			callback = function(event)
				-- NOTE: Remember that Lua is a real programming language, and as such it is possible
				-- to define small helper and utility functions so you don't have to repeat yourself.
				--
				-- In this case, we create a function that lets us more easily define mappings specific
				-- for LSP related items. It sets the mode, buffer and description for us each time.
				local map = function(keys, func, desc)
					vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
				end

				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')

				-- Same as above, but open to vertical split
				-- map('gd', function()
				-- 	require('telescope.builtin').lsp_definitions { jump_type = 'vsplit' }
				-- end, '[g]oto [d]efinition')

				-- Find references for the word under your cursor.
				map('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')

				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				map('gi', require('telescope.builtin').lsp_implementations, '[g]oto [i]mplementation')

				-- Jump to the type of the word under your cursor.
				--  Useful when you're not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')

				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [S]ymbols')

				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')

				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map('<leader>ca', vim.lsp.buf.code_action, '[c]ode [A]ction')

				-- Opens a popup that displays documentation about the word under your cursor
				--  See `:help K` for why this keymap.
				map('K', vim.lsp.buf.hover, 'Hover Documentation')

				-- WARN: This is not Goto Definition, this is Goto Declaration.
				--  For example, in C this would take you to the header.
				map('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
					vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd('LspDetach', {
						group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
						end,
					})
				end

				-- The following autocommand is used to enable inlay hints in your
				-- code, if the language server you are using supports them
				--
				-- This may be unwanted, since they displace some of your code
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map('<leader>th', function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, '[t]oggle Inlay [h]ints')
				end
			end,
		})

		-- additional modifications for ruff and pyright
		-- defer textDocument/hover to pyright
		vim.api.nvim_create_autocmd('LspAttach', {
			group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client == nil then
					return
				end
				if client.name == 'ruff' then
					-- Disable hover in favor of Pyright
					client.server_capabilities.hoverProvider = false
				end
			end,
			desc = 'LSP: Disable hover capability from Ruff',
		})

		-- -- use ruff exclusively for linting, formatting, and organizing imports
		-- require('lspconfig').pyright.setup {
		-- 	settings = {
		-- 		pyright = {
		-- 			-- Using Ruff's import organizer
		-- 			disableOrganizeImports = true,
		-- 		},
		-- 		python = {
		-- 			analysis = {
		-- 				-- Ignore all files for analysis to exclusively use Ruff for linting
		-- 				ignore = { '*' },
		-- 			},
		-- 		},
		-- 	},
		-- }

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
		capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

		-- -- Adjust capabilities for UFO folding
		-- capabilities.textDocument.foldingRange = {
		-- 	dynamicRegistration = false,
		-- 	lineFoldingOnly = true,
		-- }

		-- The servers table comprises of the following sub-tables:
		-- 1. mason
		-- 2. others
		-- Both these tables have an identical structure of language server names as keys and
		-- a table of language server configuration as values.
		---@class LspServersConfig
		---@field mason table<string, vim.lsp.Config>
		---@field others table<string, vim.lsp.Config>
		local servers = {
			--  Add any additional override configuration in any of the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			--
			--  Feel free to add/remove any LSPs here that you want to install via Mason. They will automatically be installed and setup.
			mason = {
				-- clangd = {},
				-- gopls = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},

				-- lua
				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = 'Replace',
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},

				-- python
				pyright = {},
				ruff = {},

				-- shell/bash scripting
				bashls = {},

				-- docker
				docker_compose_language_service = {},

				-- plaintext
				textlsp = {
					filetypes = { 'txt', 'norg' },
					documents = { norg = { parse = true } },
					settings = {
						textLSP = {
							analysers = {
								languagetool = {
									check_text = {
										on_change = false,
										on_open = true,
										on_save = true,
									},
									enabled = false,
								},
								ollama = {
									enabled = false,
									check_text = {
										on_open = true,
										on_save = true,
										on_change = false,
									},
									model = 'phi3:3.8b-instruct', -- smaller but faster model
									-- model = 'phi3:14b-instruct', -- more accurate
									max_token = 50,
								},
							},
							documents = {
								norg = {
									parse = true,
								},
							},
						},
					},
				},

				typos_lsp = {},

				-- toml
				taplo = {},
			},
			-- This table contains config for all language servers that are *not* installed via Mason.
			-- Structure is identical to the mason table from above.
			others = {
				-- dartls = {},
			},
		}

		-- local servers =
		-- {
		-- 	rust_analyzer = {},
		-- 	-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
		-- 	--
		-- 	-- Some languages (like typescript) have entire language plugins that can be useful:
		-- 	--    https://github.com/pmizio/typescript-tools.nvim
		-- 	--
		-- 	-- But for many setups, the LSP (`tsserver`) will work just fine
		-- 	ts_ls = {
		-- 		cmd = { 'typescript-language-server', '--stdio' },
		-- 	},
		--
		-- 	-- python
		-- 	ruff = {
		-- 		-- autostart = false,
		-- 	},
		-- 	jedi_language_server = {
		-- 		autostart = false,
		-- 		-- init_options = {
		-- 		-- 	init_options = {
		-- 		-- 		completion = {
		-- 		-- 			disableSnippets = true,
		-- 		-- 		},
		-- 		-- 		diagnostics = {
		-- 		-- 			enable = true,
		-- 		-- 		},
		-- 		-- 		workspace = {
		-- 		-- 			symbols = {
		-- 		-- 				ignoreFolders = {
		-- 		-- 					{ '.nox', '.tox', '__pycache__' },
		-- 		-- 				},
		-- 		-- 			},
		-- 		-- 		},
		-- 		-- 	},
		-- 		-- },
		-- 	},
		-- 	pylsp = {
		-- 		autostart = false,
		-- 		settings = {
		-- 			pylsp = {
		-- 				plugins = {
		-- 					pycodestyle = {
		-- 						enabled = false,
		-- 					},
		-- 					autopep8 = {
		-- 						enabled = false,
		-- 					},
		-- 					yapf = {
		-- 						enabled = false,
		-- 					},
		-- 					pyflakes = {
		-- 						enabled = false,
		-- 					},
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		--
		-- 	pyright = {
		-- 		autostart = false,
		-- 	},
		--
		-- 	-- shell/bash scripting
		-- 	bashls = {}
		--
		-- 	-- docker
		-- 	docker_compose_language_service = {},
		--
		-- 	-- lua
		-- 	lua_ls = {
		-- 		settings = {
		-- 			Lua = {
		-- 				completion = {
		-- 					callSnippet = 'Replace',
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		--
		-- 	-- regular text
		-- 	textlsp = {
		-- 		autostart = false,
		-- 		filetypes = {
		-- 			'txt',
		-- 			'norg',
		-- 		},
		-- 		settings = {
		-- 			textLSP = {
		-- 				analysers = {
		-- 					languagetool = {
		-- 						check_text = {
		-- 							on_change = false,
		-- 							on_open = true,
		-- 							on_save = true,
		-- 						},
		-- 						enabled = false,
		-- 					},
		-- 					ollama = {
		-- 						enabled = true,
		-- 						check_text = {
		-- 							on_open = true,
		-- 							on_save = true,
		-- 							on_change = false,
		-- 						},
		-- 						-- model = 'phi3:3.8b-instruct', -- smaller but faster model
		-- 						model = 'phi3:14b-instruct', -- more accurate
		-- 						max_token = 50,
		-- 					},
		-- 				},
		-- 				documents = {
		-- 					norg = {
		-- 						parse = true,
		-- 					},
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		--
		-- 	typos_lsp = {
		-- 		-- autostart = false,
		-- 		-- Logging level of the language server. Logs appear in :LspLog. Defaults to error.
		-- 		cmd_env = { RUST_LOG = 'error' },
		-- 		init_options = {
		-- 			-- Custom config. Used together with any workspace config files, taking precedence for
		-- 			-- settings declared in both. Equivalent to the typos `--config` cli argument.
		-- 			-- config = '~/code/typos-lsp/crates/typos-lsp/tests/typos.toml',
		-- 			-- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
		-- 			-- Defaults to error.
		-- 			diagnosticSeverity = 'Error',
		-- 		},
		-- 	},
		--
		-- 	-- toml
		-- 	taplo = {},
		--
		-- 	-- C-related
		-- 	clangd = {},
		-- },

		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		require('mason').setup()

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers.mason or {})
		vim.list_extend(ensure_installed, {
			'stylua', -- Used to format Lua code
			'shellcheck',
			'shfmt',
			'clang-format',
		})
		require('mason-tool-installer').setup { ensure_installed = ensure_installed }

		-- Either merge all additional server configs from the `servers.mason` and `servers.others` tables
		-- to the default language server configs as provided by nvim-lspconfig or
		-- define a custom server config that's unavailable on nvim-lspconfig.
		for server, config in pairs(vim.tbl_extend('keep', servers.mason, servers.others)) do
			if not vim.tbl_isempty(config) then
				vim.lsp.config(server, config)
			end
		end

		-- After configuring our language servers, we now enable them
		require('mason-lspconfig').setup {
			---@type string[]
			ensure_installed = {},

			---@type boolean
			automatic_enable = true, -- automatically run vim.lsp.enable() for all servers that are installed via Mason
		}

		-- Manually run vim.lsp.enable for all language servers that are *not* installed via Mason
		if not vim.tbl_isempty(servers.others) then
			vim.lsp.enable(vim.tbl_keys(servers.others))
		end

		-- ---@type boolean
		-- automatic_installation = false,
		--
		-- ---@type table<string, fun(server_name:string)>?
		-- handlers = {
		-- 	function(server_name)
		-- 		local server = servers[server_name] or {}
		--
		-- 		-- This handles overriding only values explicitly passed
		-- 		-- by the server configuration above. Useful when disabling
		-- 		-- certain features of an LSP (for example, turning off formatting for tsserver)
		-- 		server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
		--
		-- 		-- Extend the server's capabilities with blink.bmp
		-- 		require('lspconfig')[server_name].setup(server)
		-- 	end,
		-- },
		-- }
	end,
}
