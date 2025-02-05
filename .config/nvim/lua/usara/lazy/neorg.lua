return { -- neorg support, better notes
	'nvim-neorg/neorg',
	dependencies = { 'luarocks.nvim' },
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
					config = {
						engine = 'nvim-cmp',
					},
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
			},
		}
	end,
}
