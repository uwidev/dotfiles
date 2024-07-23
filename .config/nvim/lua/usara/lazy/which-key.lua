return { -- Useful plugin to show you pending keybinds.
	'folke/which-key.nvim',
	priority = 999, -- load before plugins so they can add keys as well
	event = 'VimEnter', -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		require('which-key').setup()

		-- Document existing key chains
		require('which-key').add {
			{ '<leader>c', group = '[c]ode' },
			{ '<leader>d', group = '[d]ocument' },
			-- { '<leader>r', group = '[r]ename' },
			{ '<leader>s', group = '[s]earch' },
			{ '<leader>w', group = '[w]orkspace' },
			{ '<leader>t', group = '[t]oggle' },
			{ '<leader>h', group = 'Git [h]unk' },
			{ '<leader>q', group = '[q]uit to yazi' },
		}
		-- visual mode
		require('which-key').add({
			{ '<leader>h', group = 'Git [h]unk' },
			{ '<leader>m', group = '[m]ove visual' },
			{ '<leader>g', group = '[g]it' },
		}, { mode = 'v' })
	end,
}
