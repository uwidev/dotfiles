-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
	{ -- Official lua package manager, required for neorg
		'vhyrro/luarocks.nvim',
		priority = 1000,
		config = true,
		opts = {
			rocks = { 'inspect' },
		},
	},
	{ -- Autosaving
		'https://git.sr.ht/~alowain/auto-save.nvim',
		event = { 'BufReadPre' },
		opts = {
			events = { 'InsertLeave', 'BufLeave' },
			silent = false,
			include_ft = { 'norg' }, -- Whitelist only for .neorg files
			exclude_ft = {},
		},
		-- This plugin does not seem to have a toggle feature.
		-- See the following repo if you want to consider extending existing
		-- autosave plugins with toggles.
		-- https://github.com/pocco81/auto-save.nvim
		--
		-- You can alternatively ditch plugins all together and jerry-rig your own
		-- auto commands and functions to toggle the autocommand. Do note that
		-- auto commands do not inheritly support toggle, so it's the callback
		-- that will need to handle checking if some global variable is set or not.
	},
}
