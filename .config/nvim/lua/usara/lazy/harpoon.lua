return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
	config = function()
		local harpoon = require 'harpoon'
		harpoon:setup {}

		-- Managing harpoons
		vim.keymap.set('n', '<leader>wa', function()
			harpoon:list():add()
		end, { desc = '[w]indow [a]dd to harpoon' })
		vim.keymap.set('n', '<leader>wL', function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = '[w]indow [L]ist harpoons' })

		-- Quick access harpoons
		vim.keymap.set('n', '<leader>wh', function()
			harpoon:list():select(1)
		end, { desc = '[w]indow harpoon 1' })
		vim.keymap.set('n', '<leader>wj', function()
			harpoon:list():select(2)
		end, { desc = '[w]indow harpoon 2' })
		vim.keymap.set('n', '<leader>wk', function()
			harpoon:list():select(3)
		end, { desc = '[w]indow harpoon 3' })
		vim.keymap.set('n', '<leader>wl', function()
			harpoon:list():select(4)
		end, { desc = '[w]indow harpoon 4' })

		-- Loose access harpoons
		vim.keymap.set('n', '<leader>wp', function()
			harpoon:list():prev()
		end, { desc = '[w]indow [n]ext harpoon' })
		vim.keymap.set('n', '<leader>wn', function()
			harpoon:list():next()
		end, { desc = '[w]indow [p]rev harpoon' })

		-- Telescope support
		local conf = require('telescope.config').values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require('telescope.pickers')
				.new({}, {
					prompt_title = 'Harpoon',
					finder = require('telescope.finders').new_table {
						results = file_paths,
					},
					previewer = conf.file_previewer {},
					sorter = conf.generic_sorter {},
				})
				:find()
		end

		vim.keymap.set('n', '<leader>ww', function()
			toggle_telescope(harpoon:list())
		end, { desc = 'Open harpoon [w]indo[w]' })
	end,
}
