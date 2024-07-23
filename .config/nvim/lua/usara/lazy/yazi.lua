---@type LazySpec
return {
	'mikavilpas/yazi.nvim',
	event = 'VeryLazy',
	keys = {
		{
			'<leader>qw',
			function()
				require('yazi').yazi()
			end,
			desc = 'yazi to buf dir',
		},
		{
			'<leader>qq',
			function()
				require('yazi').yazi(nil, vim.fn.getcwd())
			end,
			desc = 'yazi to cwd',
		},
	},
	---@type YaziConfig
	opts = {
		-- Below is the default configuration. It is optional to set these values.
		-- You can customize the configuration for each yazi call by passing it to
		-- yazi() explicitly

		-- enable this if you want to open yazi instead of netrw.
		-- Note that if you enable this, you need to call yazi.setup() to
		-- initialize the plugin. lazy.nvim does this for you in certain cases.
		--
		-- If you are also using neotree, you may prefer not to bring it up when
		-- opening a directory:
		-- {
		--   "nvim-neo-tree/neo-tree.nvim",
		--   opts = {
		--     filesystem = {
		--       hijack_netrw_behavior = "disabled",
		--     },
		--   },
		-- }
		open_for_directories = true,

		-- an upcoming optional feature. See
		-- https://github.com/mikavilpas/yazi.nvim/pull/152
		use_ya_for_events_reading = true,

		-- an upcoming optional feature. See
		-- https://github.com/mikavilpas/yazi.nvim/pull/180
		highlight_groups = {
			-- NOTE: this only works if `use_ya_for_events_reading` is enabled, etc.
			hovered_buffer = nil,
		},

		-- the floating window scaling factor. 1 means 100%, 0.9 means 90%, etc.
		floating_window_scaling_factor = 0.9,

		-- the transparency of the yazi floating window (0-100). See :h winblend
		yazi_floating_window_winblend = 0,

		-- the log level to use. Off by default, but can be used to diagnose
		-- issues. You can find the location of the log file by running
		-- `:checkhealth yazi` in Neovim. Also check out the "reproducing issues"
		-- section below
		log_level = vim.log.levels.OFF,

		-- what Neovim should do a when a file was opened (selected) in yazi.
		-- Defaults to simply opening the file.
		-- open_file_function = function(chosen_file, config) end,

		-- completely override the keymappings for yazi. This function will be
		-- called in the context of the yazi terminal buffer.
		-- set_keymappings_function = function(yazi_buffer_id, config) end,

		-- the type of border to use for the floating window. Can be many values,
		-- including 'none', 'rounded', 'single', 'double', 'shadow', etc. For
		-- more information, see :h nvim_open_win
		yazi_floating_window_border = 'rounded',

		-- hooks = {
		-- 	-- if you want to execute a custom action when yazi has been opened,
		-- 	-- you can define it here.
		-- 	yazi_opened = function(preselected_path, yazi_buffer_id, config)
		-- 		-- you can optionally modify the config for this specific yazi
		-- 		-- invocation if you want to customize the behaviour
		-- 	end,
		--
		-- 	-- when yazi was successfully closed
		-- 	yazi_closed_successfully = function(chosen_file, config) end,
		--
		-- 	-- when yazi opened multiple files. The default is to send them to the
		-- 	-- quickfix list, but if you want to change that, you can define it here
		-- 	yazi_opened_multiple_files = function(chosen_files, config, state) end,
		-- },

		-- integrations = {
		-- 	--- What should be done when the user wants to grep in a directory
		-- 	---@param directory string
		-- 	grep_in_directory = function(directory)
		-- 		-- the default implementation uses telescope if available, otherwise nothing
		-- 	end,
		-- },
	},
}

-- return {
-- 	'rolv-apneseth/tfm.nvim',
-- 	lazy = false,
-- 	opts = {
-- 		-- TFM to use
-- 		-- Possible choices: "ranger" | "nnn" | "lf" | "vifm" | "yazi" (default)
-- 		file_manager = 'yazi',
-- 		-- Replace netrw entirely
-- 		-- Default: false
-- 		replace_netrw = true,
-- 		-- Enable creation of commands
-- 		-- Default: false
-- 		-- Commands:
-- 		--   Tfm: selected file(s) will be opened in the current window
-- 		--   TfmSplit: selected file(s) will be opened in a horizontal split
-- 		--   TfmVsplit: selected file(s) will be opened in a vertical split
-- 		--   TfmTabedit: selected file(s) will be opened in a new tab page
-- 		enable_cmds = false,
-- 		-- Custom keybindings only applied within the TFM buffer
-- 		-- Default: {}
-- 		keybindings = {
-- 			['<ESC>'] = 'q',
-- 			-- Override the open mode (i.e. vertical/horizontal split, new tab)
-- 			-- Tip: you can add an extra `<CR>` to the end of these to immediately open the selected file(s) (assuming the TFM uses `enter` to finalise selection)
-- 			['<C-v>'] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.vsplit)<CR>",
-- 			['<C-x>'] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.split)<CR>",
-- 			['<C-t>'] = "<C-\\><C-O>:lua require('tfm').set_next_open_mode(require('tfm').OPEN_MODE.tabedit)<CR>",
-- 		},
-- 		-- Customise UI. The below options are the default
-- 		ui = {
-- 			border = 'rounded',
-- 			height = 1,
-- 			width = 1,
-- 			x = 0.5,
-- 			y = 0.5,
-- 		},
-- 	},
-- 	keys = {
-- 		-- Make sure to change these keybindings to your preference,
-- 		-- and remove the ones you won't use
-- 		{
-- 			'<leader>e',
-- 			':Tfm<CR>',
-- 			desc = 'TFM',
-- 		},
-- 		{
-- 			'<leader>mh',
-- 			':TfmSplit<CR>',
-- 			desc = 'TFM - horizontal split',
-- 		},
-- 		{
-- 			'<leader>mv',
-- 			':TfmVsplit<CR>',
-- 			desc = 'TFM - vertical split',
-- 		},
-- 		{
-- 			'<leader>mt',
-- 			':TfmTabedit<CR>',
-- 			desc = 'TFM - new tab',
-- 		},
-- 	},
-- }
