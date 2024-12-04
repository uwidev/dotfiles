-- Nerd
vim.g.have_nerd_font = true

-- Show line numbers and use relative
vim.opt.number = true
vim.opt.relativenumber = true

-- Set indent
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1 -- use same value as shiftwidth
vim.opt.expandtab = false

vim.opt.autoindent = true
vim.opt.smartindent = true

-- Do not use PEP8 for my own projects
vim.g.python_recommended_style = 0

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

-- Word wrap adjustment
-- vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = '󱞩 '
vim.opt.breakindentopt = 'min:40,sbr'

-- Better history management and concurrent editing
vim.opt.undofile = true -- Undotree all the way
vim.opt.swapfile = false
vim.opt.backup = false

-- See https://www.reddit.com/r/vim/comments/7uac23/comment/dtjdinh/?utm_source=share&utm_medium=web2x&context=3
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
	desc = 'Always update buffer to latest changes',
	pattern = '*',
	command = 'checktime',
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time, mainly useful for CursorHold events
vim.opt.updatetime = 50

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Declare dev highlight groups to be later defined by lushwal
for i = 0, 15 do
	vim.api.nvim_set_hl(0, string.format('DevColor%d', i), {})
end
