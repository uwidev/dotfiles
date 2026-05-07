require('usara.plugins.lushwal')
vim.pack.add { gh 'lukas-reineke/virt-column.nvim' }

require('virt-column').setup {
		-- char = '│', -- thinner variant
		highlight = 'VirtColumn'
}
