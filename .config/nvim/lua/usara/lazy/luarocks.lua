return { -- Official lua package manager, required for neorg
	{
		'vhyrro/luarocks.nvim',
		priority = 1000,
		config = true,
		opts = {
			rocks = { 'inspect' },
		},
	},
}
