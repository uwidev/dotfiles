vim.pack.add { gh 'uwidev/lushwal.nvim'}
vim.pack.add { gh 'HiPhish/rainbow-delimiters.nvim' }

require('rainbow-delimiters.setup').setup {
	strategy = {
		[''] = 'rainbow-delimiters.strategy.global',
		vim = 'rainbow-delimiters.strategy.local',
	},
	query = {
		[''] = 'rainbow-delimiters',
		lua = 'rainbow-blocks',
	},
	priority = {
		[''] = 110,
		lua = 210,
	},
	highlight = {
		'RedBack',
		'GreenBack',
		'YellowBack',
		'BlueBack',
		'MagentaBack',
		'CyanBack',
	},
}
