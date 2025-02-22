-- https://github.com/dedukun/relative-motions.yazi
require("relative-motions"):setup({ show_numbers = "relative", show_motion = true })

-- https://github.com/dedukun/bookmarks.yazi
require("bookmarks"):setup({
	save_last_directory = false, -- DEPRECATED - will be removed in the future. Use `last_directory`
	last_directory = { enable = false, persist = false },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "hover",
	notify = {
		enable = false,
		timeout = 1,
		message = {
			new = "New bookmark '<key>' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

-- https://github.com/AnirudhG07/plugins-yazi/tree/main/copy-file-contents.yazi
require("copy-file-contents"):setup({
	clipboard_cmd = "wl-copy",
	append_char = "\n",
	notification = true,
})

THEME.git = THEME.bit or {}
THEME.git.modified_sign = "󰔶"
THEME.git.added_sign = "󰐕"
THEME.git.untracked_sign = "?"
THEME.git.ignored_sign = ""
THEME.git.deleted_sign = ""
THEME.git.updated_sign = "󰁝"

require("git"):setup()
