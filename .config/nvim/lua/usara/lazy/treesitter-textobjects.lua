return {
	'nvim-treesitter/nvim-treesitter-textobjects',
	dependencies = { 'nvim-treesitter/nvim-treesitter' },
	config = function()
		require('nvim-treesitter.configs').setup {
			textobjects = {
				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {

						-- Functions
						-- m to overwrite default python.vim plugin, which uses m
						['am'] = '@function.outer',
						['im'] = '@function.inner',

						-- Parameters
						['aa'] = '@parameter.outer',
						['ia'] = '@parameter.inner',

						['ac'] = '@class.outer',
						['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },

						-- Blocks (indentation) for indentation languages (Python)
						-- B, as b is an alias for )]}> for mini.ai
						['aB'] = '@block.outer',
						['iB'] = '@block.inner',

						-- Statements, namely when they are split to newlines
						-- S, as s is reserved for sentence
						['aS'] = '@statement.outer',
					},

					-- You can choose the select mode (default is charwise 'v')
					selection_modes = {
						['@function.outer'] = 'V',
						['@class.outer'] = 'V',
					},

					include_surrounding_whitespace = true,
				},

				swap = {
					enable = true,
					swap_next = {
						['<leader>a'] = '@parameter.inner',
					},
					swap_previous = {
						['<leader>A'] = '@parameter.inner',
					},
				},

				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						[']f'] = '@function.outer',
						[']c'] = { query = '@class.outer', desc = 'Next class start' },
						--
						-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
						[']o'] = '@loop.*',
						-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
						--
						-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
						-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
						[']s'] = { query = '@local.scope', query_group = 'locals', desc = 'Next scope' },
						[']z'] = { query = '@fold', query_group = 'folds', desc = 'Next fold' },
					},
					goto_next_end = {
						[']F'] = '@function.outer',
						[']C'] = '@class.outer',
					},
					goto_previous_start = {
						['[f'] = '@function.outer',
						['[c'] = '@class.outer',
					},
					goto_previous_end = {
						['[F'] = '@function.outer',
						['[C'] = '@class.outer',
					},
					-- Below will go to either the start or the end, whichever is closer.
					-- Use if you want more granular movements
					-- Make it even more gradual by adding multiple queries and regex.
					goto_next = {
						[']d'] = '@conditional.outer',
					},
					goto_previous = {
						['[d'] = '@conditional.outer',
					},
				},
			},
		}

		local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

		-- Adjust keymapping to allow repeat with ; and ,
		-- Repeat movement with ; and ,
		-- ensure ; goes forward and , goes backward regardless of the last direction
		-- vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
		-- vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

		-- vim way: ; goes to the direction you were moving.
		vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
		vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)

		-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
		vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
		vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
		vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
		vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
	end,
}
