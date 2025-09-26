return {
	'VPavliashvili/json-nvim',
	config = function()
		vim.keymap.set('n', '<leader>fj', '<cmd>JsonFormatFile<cr>')
		vim.keymap.set('n', '<leader>fJ', '<cmd>JsonMinifyFile<cr>')
	end,
}
