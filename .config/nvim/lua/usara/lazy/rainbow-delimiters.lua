return {
	'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
	dependencies = { 'uwidev/lushwal.nvim' },
	priority = 0,
	config = function()
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
	end,
}
