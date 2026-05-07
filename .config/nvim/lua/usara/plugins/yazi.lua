vim.pack.add { gh 'mikavilpas/yazi.nvim' }
require('yazi').setup {
	-- if you want to open yazi instead of netrw, see below for more info
	open_for_directories = false,
	keymaps = {
		show_help = '<f1>',
	},
}

vim.keymap.set('n', '<leader>qw', function()
	require('yazi').yazi()
end, { desc = 'yazi to buf dir' })

vim.keymap.set('n', '<leader>qq', function()
	require('yazi').yazi(nil, vim.fn.getcwd())
end, { desc = 'yazi to buf dir' })
