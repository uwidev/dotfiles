return { -- Autocompletion
	'saghen/blink.cmp',
	event = 'VimEnter',
	version = '1.*',
	dependencies = {
		'L3MON4D3/LuaSnip',
		'folke/lazydev.nvim',
	},
	--- @module 'blink.cmp'
	--- @type blink.cmp.Config
	opts = {
		keymap = {
			preset = 'default',

			['<C-j>'] = { 'snippet_forward', 'fallback' },
			['<C-k>'] = { 'snippet_backward', 'fallback' },

			-- -- Alternative mapping
			-- ['<M-n>'] = { 'snippet_forward', 'fallback' },
			-- ['<M-N>'] = { 'snippet_backward', 'fallback' },
		},

		appearance = {
			nerd_font_variant = 'mono',
		},

		completion = {
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
		},

		sources = {
			default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
			providers = {
				lazydev = {
					module = 'lazydev.integrations.blink',
					score_offset = 100,
				},
				lsp = {
					min_keyword_length = function(ctx)
						return ctx.trigger.initial_kind == 'manual' and 0 or 2
					end,
				},
				path = {
					min_keyword_length = function(ctx)
						return ctx.trigger.initial_kind == 'manual' and 0 or 0
					end,
				},
				snippets = {
					min_keyword_length = function(ctx)
						return ctx.trigger.initial_kind == 'manual' and 0 or 2
					end,
				},
				buffer = {
					min_keyword_length = function(ctx)
						return ctx.trigger.initial_kind == 'manual' and 0 or 4
					end,
					max_items = 5,
				},
			},
		},

		snippets = { preset = 'luasnip' },

		fuzzy = { implementation = 'prefer_rust_with_warning' },

		signature = { enabled = true },

		cmdline = {
			enabled = true,
			completion = {
				menu = {
					auto_show = true,
				},
			},
		},
	},
}
