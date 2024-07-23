return {
	'ray-x/lsp_signature.nvim',
	dependencies = {
		'neovim/nvim-lspconfig',
	},
	event = 'VeryLazy',
	opts = {
		bind = true,
		handler_opts = {
			border = 'rounded',
		},
		hint_prefix = ' ',
	},
	config = function(_, opts)
		require('lsp_signature').setup(opts)
	end,
}
