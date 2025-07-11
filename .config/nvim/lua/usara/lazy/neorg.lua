return { -- neorg support, better notes
	'nvim-neorg/neorg',
	dependencies = { 'luarocks.nvim', 'benlubas/neorg-interim-ls', 'benlubas/neorg-conceal-wrap' },
	lazy = false,
	version = '*',
	config = function()
		require('neorg').setup {
			load = {
				['core.defaults'] = {},
				['core.concealer'] = {
					config = {
						icons = {
							heading = {
								icons = {
									'󰉫',
									'󰉬',
									'󰉭',
									'󰉮',
									'󰉯',
									'󰉰',
								},
							},
							todo = {
								undone = {
									icon = ' ',
								},
								pending = {
									icon = '',
								},
								recurring = {
									icon = '',
								},
								cancelled = {
									icon = '',
								},
								on_hold = {
									icon = '󰏤',
								},
								urgent = {
									icon = '',
								},
							},
						},
					},
				},
				['core.qol.todo_items'] = {
					config = {
						order = {
							{ 'undone', ' ' },
							{ 'pending', '-' },
							{ 'done', 'x' },
						},
					},
				},
				['core.dirman'] = {
					config = {
						workspaces = {
							notes = '~/docs/notes',
							journal = '~/docs/notes/journal',
						},
					},
				},
				['core.journal'] = {
					config = {
						strategy = 'flat',
						workspace = 'notes',
					},
				},
				['core.completion'] = {
					config = { engine = { module_name = 'external.lsp-completion' } },
					-- config = {
					-- 	engine = 'nvim-cmp',
					-- },
				},
				['core.integrations.nvim-cmp'] = {},
				['core.keybinds'] = {
					config = {
						hook = function(keybinds)
							keybinds.remap(
								'norg',
								'x',
								'<leader>mf',
								':<C-u>lua require("usara.move_visual_new_file").simple_refactor(vim.api.nvim_get_mode().mode)<CR>',
								{ noremap = true, silent = true, desc = '(m)ove visual to (f)ile' }
							)
						end,
					},
				},
				['external.interim-ls'] = {
					config = {
						-- default config shown
						completion_provider = {
							-- Enable or disable the completion provider
							enable = true,

							-- Show file contents as documentation when you complete a file name
							documentation = true,

							-- Try to complete categories provided by Neorg Query. Requires `benlubas/neorg-query`
							categories = false,

							-- suggest heading completions from the given file for `{@x|}` where `|` is your cursor
							-- and `x` is an alphanumeric character. `{@name}` expands to `[name]{:$/people:# name}`
							people = {
								enable = false,

								-- path to the file you're like to use with the `{@x` syntax, relative to the
								-- workspace root, without the `.norg` at the end.
								-- ie. `folder/people` results in searching `$/folder/people.norg` for headings.
								-- Note that this will change with your workspace, so it fails silently if the file
								-- doesn't exist
								path = 'people',
							},
						},
					},
				},
				['external.conceal-wrap'] = {},
			},
		}
	end,
}
