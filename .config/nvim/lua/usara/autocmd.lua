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

-- -- Fix for folds. A race condition nvim_treesitter.foldexpr() is called before
-- -- treesitter can set up the syntax tree. It results in folds not working
-- -- until manually updated
-- -- https://stackoverflow.com/questions/79716150/treesitter-based-python-code-folding-not-applied-when-initially-loading-file-in
-- -- Create group to assign commands
-- -- "clear = true" must be set to prevent loading an auto-command repeatedly every time a file is resourced
-- local autocmd_group = vim.api.nvim_create_augroup('Custom auto-commands', { clear = true })
-- vim.api.nvim_create_autocmd('BufReadPost', {
-- 	pattern = '*.py',
-- 	desc = 'Apply code folds after reading Python file into buffer (uses vim.schedule)',
-- 	callback = function()
-- 		vim.schedule(function()
-- 			vim.cmd 'normal! zx'
-- 		end)
-- 	end,
-- 	group = autocmd_group,
-- })


-- change window title on bufenter
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.opt.titlestring = 'nvim ' .. vim.fn.fnamemodify(vim.fn.expand('%:p'), ':~')
    end,
})
