-- This file is to include autocmd innate to primitive neovim.
-- There may be more autocommands created during the plugin configuration.

-- [[ Basic Autocommands from Kickstart ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Automatically turn on spellcheck for specific files
vim.api.nvim_create_augroup('SpellCheck', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
	group = 'SpellCheck',
	pattern = { 'norg', 'txt' },
	command = 'setlocal spell spelllang=en_us',
})
