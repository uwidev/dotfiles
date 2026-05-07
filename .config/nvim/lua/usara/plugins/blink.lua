vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
require('blink.cmp').setup {
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
		default = { 'lsp', 'path', 'snippets', 'buffer' },
		providers = {
			-- do not immediately show completion to promote better cognition
			-- and learning of codebases
			--
			-- if need to force suggestions to open do <A-Space>
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
}
