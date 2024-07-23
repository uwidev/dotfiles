return {
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		'uwidev/lushwal.nvim',
		-- 'oncomouse/lushwal.nvim',
		priority = 1000, -- Make sure to load this before all the other/start plugins.
		cmd = { 'LushwalCompile' },
		dependencies = {
			{ 'rktjmp/lush.nvim' },
			{ 'rktjmp/shipwright.nvim' },
		},
		init = function()
			require('lushwal').compile()
			vim.cmd.colorscheme 'lushwal'
		end,
		config = function()
			vim.g.lushwal_configuration = {
				addons = {
					nvim_cmp = true,
					mini_nvim = true,
					which_key_nvim = true,
					gitsigns = true,
					telescope_nvim = true,
					vim_gitgutter = true,
					virt_column = true,
					dev = true,
				},
			}
		end,
	},
	-- Other themes that you may want to install.
	-- 'uZer/pywal16',
	'folke/tokyonight.nvim',
	-- 'AlphaTechnolog/pywal.nvim',
	'catppuccin/nvim',
}
