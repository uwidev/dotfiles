require('usara.plugins.lushwal')
vim.pack.add { gh 'lukas-reineke/indent-blankline.nvim' }

require('ibl').setup {
	indent = {
		char = '├',
		tab_char = '│',

		highlight = {
			'Red',
			'Green',
			'Yellow',
			'Blue',
			'Magenta',
			'Cyan',
		},

	},
}
