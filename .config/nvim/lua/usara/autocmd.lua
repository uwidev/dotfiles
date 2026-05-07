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

-- change window title on bufenter
vim.api.nvim_create_autocmd('BufEnter', {
	pattern = '*',
	callback = function()
		vim.opt.titlestring = 'nvim ' .. vim.fn.fnamemodify(vim.fn.expand '%:p', ':~')
	end,
})
