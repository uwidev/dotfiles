return {
	{ -- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		opts = {
			enabled = true,
			indent = {
				char = '├',
				tab_char = { '│' },
				highlight = {
					'DevColor1',
					'DevColor2',
					'DevColor3',
					'DevColor4',
					'DevColor5',
					'DevColor6',
				},
				repeat_linebreak = false,
			},
		},
	},
}
