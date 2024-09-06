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
		{ 'folke/neodev.nvim', opts = {} },
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

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn't support everything that is in the LSP specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local servers =
			{
				rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`tsserver`) will work just fine
				tsserver = {
					cmd = { 'typescript-language-server', '--stdio' },
				},

				-- python
				ruff_lsp = {
					autostart = false,
					opts = {
						cmd_env = { RUFF_TRACE = 'messages' },
					},
				},
				ruff = {
					-- autostart = false,
					settings = {
						-- args = { '--config=./pyproject.toml' },
					},
				},
				jedi_language_server = {
					autostart = false,
					-- init_options = {
					-- 	init_options = {
					-- 		completion = {
					-- 			disableSnippets = true,
					-- 		},
					-- 		diagnostics = {
					-- 			enable = true,
					-- 		},
					-- 		workspace = {
					-- 			symbols = {
					-- 				ignoreFolders = {
					-- 					{ '.nox', '.tox', '__pycache__' },
					-- 				},
					-- 			},
					-- 		},
					-- 	},
					-- },
				},
				pylsp = {
					-- autostart = false,
					settings = {
						pylsp = {
							plugins = {
								pycodestyle = {
									enabled = false,
								},
								autopep8 = {
									enabled = false,
								},
								yapf = {
									enabled = false,
								},
								pyflakes = {
									enabled = false,
								},
							},
						},
					},
				},
				pyright = {
					autostart = false,
				},

				-- shell/bash scripting
				bashls = {},

				-- docker
				docker_compose_language_service = {},

				-- lua
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = 'Replace',
							},
						},
					},
				},

				-- regular text
				textlsp = {
					autostart = false,
					filetypes = {
						'txt',
						'norg',
					},
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
									enabled = true,
									check_text = {
										on_open = true,
										on_save = true,
										on_change = false,
									},
									-- model = 'phi3:3.8b-instruct', -- smaller but faster model
									model = 'phi3:14b-instruct', -- more accurate
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
				typos_lsp = {
					-- autostart = false,
					-- Logging level of the language server. Logs appear in :LspLog. Defaults to error.
					cmd_env = { RUST_LOG = 'error' },
					init_options = {
						-- Custom config. Used together with any workspace config files, taking precedence for
						-- settings declared in both. Equivalent to the typos `--config` cli argument.
						-- config = '~/code/typos-lsp/crates/typos-lsp/tests/typos.toml',
						-- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
						-- Defaults to error.
						diagnosticSeverity = 'Error',
					},
				},
			},
			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install
			--  other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu.
			require('mason').setup()

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			'stylua', -- Used to format Lua code
			'shellcheck',
			'shfmt',
		})
		require('mason-tool-installer').setup { ensure_installed = ensure_installed }

		require('mason-lspconfig').setup {
			handlers = {
				function(server_name)
					-- Temporary patch while we wait for Mason to update for ts_ls
					-- https://github.com/williamboman/mason-lspconfig.nvim/issues/458
					if server_name == 'tsserver' then
						server_name = 'ts_ls'
					end

					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
					-- if server_name == 'textlsp' then
					--   local inspect = require 'inspect'
					--   print(inspect(server))
					-- end
					require('lspconfig')[server_name].setup(server)
				end,
			},
		}
		-- vim.lsp.set_log_level 'debug',
		-- require('lspconfig').anakin_language_server.setup {}
		-- require('lspconfig').textlsp.setup {
		--   settings = {
		--     textLSP = {
		--       analysers = {
		--         languagetool = {
		--           enabled = false,
		--         },
		--         ollama = {
		--           enabled = true,
		--           check_text = {
		--             on_open = false,
		--             on_save = true,
		--             on_change = false,
		--           },
		--           model = 'phi3:3.8b-instruct', -- smaller but faster model
		--           -- model = "phi3:14b-instruct",  -- more accurate
		--           max_token = 50,
		--         },
		--       },
		--     },
		--   },
		-- }
	end,
}

-- return {
--   'neovim/nvim-lspconfig',
--   dependencies = {
--     -- Automatically install LSPs and related tools to stdpath for Neovim
--     { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
--     'williamboman/mason-lspconfig.nvim',
--     'WhoIsSethDaniel/mason-tool-installer.nvim',
--
--     -- Useful status updates for LSP.
--     -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
--     { 'j-hui/fidget.nvim', opts = {} },
--
--     -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
--     -- used for completion, annotations and signatures of Neovim apis
--   },
--   config = function()
--     require('lspconfig').textlsp.setup {}
--   end,
-- }
