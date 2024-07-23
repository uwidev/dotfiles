return { -- Use a character for the ColorColumn
	'lukas-reineke/virt-column.nvim',
	opts = {
		-- char = '│', -- thinner variant
		highlight = 'VirtColumn',
	},
	setup = function(_, opts)
		require('virt-column').setup(opts)
	end,
}
