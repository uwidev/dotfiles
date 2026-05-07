vim.pack.add { gh "rktjmp/lush.nvim"}
vim.pack.add { gh "rktjmp/shipwright.nvim"}

vim.pack.add { gh 'uwidev/lushwal.nvim' }
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

vim.cmd.colorscheme 'lushwal'
