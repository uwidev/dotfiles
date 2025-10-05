-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Move selected line up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Join line below with this line, but keep cursor in place
vim.keymap.set('n', 'J', 'mzJ`z')

-- Keep buffer centered when moving around
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Paste over selection while keeping original paste
-- Normally, when deleting the selection to paste over it, the deleted text
-- will overwrite the current register. Since in cases like this, our usual
-- intention is to forget what we're overwriting, so write to blackhole reg.
vim.keymap.set('x', '<leader>p', [["_dP]])

-- Related to yanking and clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = '[y]ank system clipboard' })

vim.keymap.set({ 'n', 'v' }, '<leader>p', [[o<Esc>"+p]], { desc = '[p]aste system clipboard' })
vim.keymap.set('n', '<leader>p', [["+P]], { desc = '{P}aste above system clipboard' })

-- vim.keymap.set('n', '<leader>yl', 'm`0y$``', { desc = '[Y]ank line no \\n' })
-- vim.keymap.set('n', '<leader><S-y>l', 'm`0+y$``', { desc = '[Y]ank to system clipboard no \\n' })

-- -- Join selected lines, yank line, undo join
vim.keymap.set('v', '<leader>gJ', 'gJ"+yyu', { desc = 'yank [J]oined no space', silent = true })

-- Join selected lines, yank line, undo join
vim.keymap.set('v', '<leader>J', 'J"+yyu', { desc = 'yank [J]oined w/ space', silent = true })

-- There exists conflicting keymap <leader>d for diagnostics
-- vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], { desc = '[d]elete to blackhole' })

-- Allows for faster edit-compile-edit cycles
-- see `:h quickfix`
vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lprev<CR>zz')
vim.keymap.set('n', '<M-j>', '<cmd>bn<CR>zz')
vim.keymap.set('n', '<M-k>', '<cmd>bp<CR>zz')

vim.keymap.set('n', '<leader>sS', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = '[s]earch and [S]ubstitute under cursor' })
vim.keymap.set({ 'v' }, '<leader>s', [[y|:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]], { desc = '[s]earch and sbstitute (v)isual' })

-- ez chmod +x
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true, desc = 'chmod +[x] current file' })

-- Geometric incrementing
-- vim.keymap.set('v', 'gA', [[:s/\d\+/\=submatch(0) * /gI<Left><Left><Left>]], { desc = 'Increment visual block geometrically' })

-- [[ Basic Keymaps from Kickstart ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
-- vim.keymap.set('n', '[d', function()
-- 	vim.diagnostic.jump { count = -1 }
-- end, { desc = 'Go to previous [d]iagnostic message' })
-- vim.keymap.set('n', ']d', function()
-- 	vim.diagnostic.jump { count = 1 }
-- end, { desc = 'Go to next [d]iagnostic message' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show [d]iagnostic [e]rror messages' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open [d]iagnostic [q]uickfix list' })

-- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
vim.api.nvim_create_user_command('FormatDisable', function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = 'Disable autoformat-on-save',
	bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = 'Re-enable autoformat-on-save',
})

-- Quick reformatting
vim.keymap.set('n', '<leader>fn', ':%s/\\\\n/\\r/g<cr>', { desc = 'format [n]ew line on \\n' })
vim.keymap.set('x', '<leader>fn', ":'<,'>s/\\\\n/\\r/g<cr>", { desc = 'format [n]ew line on \\n' })
vim.keymap.set('n', '<leader>f,', ':%s/,/,\\r/g<cr>', { desc = 'format [n]new line on ,' })
vim.keymap.set('x', '<leader>f,', ":'<,'>s/,/,\\r/g<cr>", { desc = 'format [n]new line on ,' })
vim.keymap.set(
	'n',
	'<leader>fj"',
	[[:%s/\v"(\_.{-})"/\='"' . substitute(submatch(1), "\n", "\\\\n", "g") . '"'/g<cr>]],
	{ desc = 'format [j]oin \\r in ["]', silent = true }
)

-- Alter movement when word wrap is enabled
-- https://vimtricks.com/p/word-wrapping/
local wrap_enabled = false
local wrap_remapped = false
function ToggleWrap(do_remap)
	-- vim.opt.list = true
	if not wrap_enabled then --toggle on
		wrap_enabled = true
		vim.opt.wrap = true
		if do_remap and not wrap_remapped then
			wrap_remapped = true
			-- vim.opt.linebreak = true

			vim.keymap.set('n', 'j', 'gj', { noremap = true })
			vim.keymap.set('n', 'k', 'gk', { noremap = true })
			vim.keymap.set('n', '0', 'g0', { noremap = true })
			vim.keymap.set('n', '^', 'g^', { noremap = true })
			vim.keymap.set('n', '$', 'g$', { noremap = true })
			vim.keymap.set('v', 'j', 'gj', { noremap = true })
			vim.keymap.set('v', 'k', 'gk', { noremap = true })
			vim.keymap.set('v', '0', 'g0', { noremap = true })
			vim.keymap.set('v', '^', 'g^', { noremap = true })
			vim.keymap.set('v', '$', 'g$', { noremap = true })
		end
	else -- toggle off
		wrap_enabled = false
		vim.opt.wrap = false
		if wrap_remapped then
			-- vim.opt.linebreak = false
			wrap_remapped = false

			vim.api.nvim_del_keymap('n', 'j')
			vim.api.nvim_del_keymap('n', 'k')
			vim.api.nvim_del_keymap('n', '0')
			vim.api.nvim_del_keymap('n', '^')
			vim.api.nvim_del_keymap('n', '$')
			vim.api.nvim_del_keymap('v', 'j')
			vim.api.nvim_del_keymap('v', 'k')
			vim.api.nvim_del_keymap('v', '0')
			vim.api.nvim_del_keymap('v', '^')
			vim.api.nvim_del_keymap('v', '$')
		end
	end
	-- print(tostring(wrap_enabled) .. tostring(wrap_remapped))
end

if vim.o.wrap then
	ToggleWrap()
end

vim.keymap.set('n', '<leader>W', function()
	ToggleWrap(true)
end, { noremap = true, desc = 'toggle [W]rap w/ remap' })
vim.keymap.set('n', '<leader>w', function()
	ToggleWrap(false)
end, { noremap = true, desc = 'toggle [w]rap' })

-- reverse selected lines
vim.keymap.set("v", "<leader>fr", ":'<,'>!tac<CR>", { desc = "[f]ormat [r]everse" })
