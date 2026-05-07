vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
	-- Delay between pressing a key and opening which-key (milliseconds)
	delay = 0,
	icons = { mappings = vim.g.have_nerd_font },
	-- Document existing key chains
	spec = {
		{ '<leader>s', group = '[s]earch', mode = { 'n', 'v' } },
		{ '<leader>t', group = '[t]oggle' },
		{ '<leader>h', group = 'Git [h]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
		{ '<Leader>gr', group = 'LSP Actions', mode = { 'n' } },
	},
}
