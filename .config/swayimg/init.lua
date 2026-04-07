-- Example config for Swayimg.
-- This file contains the default configuration used by the application.

-- The viewer searches for the config file in the following locations:
-- 1. $XDG_CONFIG_HOME/swayimg/init.lua
-- 2. $HOME/.config/swayimg/init.lua
-- 3. $XDG_CONFIG_DIRS/swayimg/init.lua
-- 4. /etc/xdg/swayimg/init.lua

-- General config
swayimg.set_mode("viewer")					-- mode at startup
swayimg.enable_antialiasing(true)			-- anti-aliasing
swayimg.enable_exif_orientation(true)		-- image orientation by EXIF
swayimg.set_dnd_button("MouseRight")		-- drag-and-drop mouse button

-- Image list configuration
swayimg.imagelist.set_order("mtime")		-- list order
swayimg.imagelist.enable_reverse(true)		-- reverse order
swayimg.imagelist.enable_recursive(false)	-- recursive directory reading
swayimg.imagelist.enable_adjacent(true)		-- add adjacent files from same dir
swayimg.imagelist.enable_fsmon(true)		-- enable file system monitoring

-- Text overlay configuration
swayimg.text.set_font("monospace")			-- font name
swayimg.text.set_size(24)					-- font size in pixels
swayimg.text.set_spacing(0)					-- line spacing
swayimg.text.set_padding(10)				-- padding from window edge
swayimg.text.set_foreground(0xffcccccc)		-- foreground text color
swayimg.text.set_background(0x00000000)		-- text background color
swayimg.text.set_shadow(0x0d000000)			-- text shadow color
swayimg.text.set_timeout(5)					-- layer hide timeout
swayimg.text.set_status_timeout(3)	  		-- status message hide timeout
swayimg.text.hide()							-- don't show text at startup

-- Image viewer mode
swayimg.viewer.set_default_scale("optimal")						-- default image scale
swayimg.viewer.set_default_position("center")					-- default image position
swayimg.viewer.set_drag_button("MouseLeft")						-- mouse button to drag image
swayimg.viewer.set_window_background(0xff000000)				-- window background color
swayimg.viewer.set_image_chessboard(20, 0xff333333, 0xff4c4c4c)	-- chessboard
swayimg.viewer.enable_centering(true)							-- enable automatic centering
swayimg.viewer.enable_loop(true)								-- enable image list loop mode
swayimg.viewer.limit_preload(32)								-- number of images to preload
swayimg.viewer.limit_history(32)								-- number of the history cache
swayimg.viewer.set_mark_color(0xff808080)						-- mark icon color
swayimg.viewer.set_text("topleft", {							-- top left text block scheme
  "File: {name}",
  "Format: {format}",
  "File size: {sizehr}",
  "File time: {time}",
  "EXIF date: {meta.Exif.Photo.DateTimeOriginal}",
  "EXIF camera: {meta.Exif.Image.Model}"
})
swayimg.viewer.set_text("topright", {			-- top right text block scheme
  "Image: {list.index} of {list.total}",
  "Frame: {frame.index} of {frame.total}",
  "Size: {frame.width}x{frame.height}"
})
swayimg.viewer.set_text("bottomleft", {			-- bottom left text block scheme
  "Scale: {scale}"
})

-- Key and mouse bindings in viewer mode:

swayimg.viewer.on_key("q", function()
  swayimg.exit()
end)

swayimg.viewer.on_mouse("MouseMiddle", function()
  swayimg.exit()
end)

swayimg.viewer.on_mouse("MouseExtra", function()
  swayimg.viewer.switch_image("next")
end)

swayimg.viewer.on_mouse("MouseSide", function()
  swayimg.viewer.switch_image("prev")
end)

swayimg.viewer.on_key("j", function()
	swayimg.viewer.switch_image("next")
end)

swayimg.viewer.on_key("k", function()
	swayimg.viewer.switch_image("prev")
end)

swayimg.viewer.on_key("r", function()
	swayimg.viewer.set_default_scale("real")
end)

swayimg.viewer.on_key("z", function()
	swayimg.viewer.set_fix_scale("optimal")
	swayimg.viewer.set_default_scale("optimal")
end)

swayimg.viewer.on_key("x", function()
	swayimg.viewer.set_fix_scale("width")
	swayimg.viewer.set_default_scale("width")
end)

swayimg.viewer.on_key("c", function()
	swayimg.viewer.set_fix_scale("height")
	swayimg.viewer.set_default_scale("height")
end)

swayimg.viewer.on_key("e", function()
	swayimg.viewer.set_fix_scale("keep")
	swayimg.viewer.set_default_scale("keep")
end)

swayimg.viewer.on_mouse("ScrollUp", function()
	local scale = swayimg.viewer.get_scale()
	swayimg.viewer.set_abs_scale(scale+0.05)
end)

swayimg.viewer.on_mouse("ScrollDown", function()
	local scale = swayimg.viewer.get_scale()
	swayimg.viewer.set_abs_scale(scale-0.05)
end)

-- Gallery mode
swayimg.gallery.set_aspect("fill")					-- thumbnail aspect ratio
swayimg.gallery.set_thumb_size(200)					-- thumbnail size in pixels
swayimg.gallery.set_padding_size(5)					-- padding between thumbnails
swayimg.gallery.set_border_size(5)					-- border size for selected thumbnail
swayimg.gallery.set_border_color(0xffaaaaaa)		-- border color for selected thumbnail
swayimg.gallery.set_selected_scale(1.15)			-- scale for selected thumbnail
swayimg.gallery.set_selected_color(0xff404040)		-- background color for selected thumbnail
swayimg.gallery.set_unselected_color(0xff202020)	-- background color for unselected thumbnail
swayimg.gallery.set_window_color(0xff000000)		-- window background color
swayimg.gallery.limit_cache(128)					-- number of thumbnails stored in memory
swayimg.gallery.enable_preload(false)				-- preloading invisible thumbnails
swayimg.gallery.enable_pstore(false)				-- enable persistent storage for thumbnails
swayimg.gallery.set_text("topleft", {				-- top left text block scheme
  "File: {name}"
})
swayimg.gallery.set_text("topright", {	-- top right text block scheme
  "{list.index} of {list.total}"
})

-- Key and mouse bindings in gallery mode:

-- bind Enter key to open image in viewer
swayimg.gallery.on_key("Return", function()
  swayimg.set_mode("viewer")
end)
-- bind the left arrow key to select thumbnail on the left side
swayimg.gallery.on_key("j", function()
  swayimg.gallery.switch_image("down")
end)
swayimg.gallery.on_key("k", function()
  swayimg.gallery.switch_image("up")
end)
swayimg.gallery.on_key("h", function()
  swayimg.gallery.switch_image("left")
end)
swayimg.gallery.on_key("l", function()
  swayimg.gallery.switch_image("right")
end)

--
-- Other configuration examples
--

-- force set scale mode on window resize (useful for tiling compositors)
swayimg.on_window_resize(function()
  swayimg.viewer.set_fix_scale("optimal")
end)

-- bind the Delete key in slide show mode to delete the current file and display a status message
swayimg.viewer.on_key("Shift+Delete", function()
  local image = swayimg.viewer.get_image()
  os.execute("trash "..image.path.."")
  local filename = image.path:match("([^/]+)$")
  swayimg.text.set_status("removed "..filename)
end)

-- set a custom window title in gallery mode
swayimg.gallery.on_image_change(function()
  local image = swayimg.gallery.get_image()
  swayimg.set_title("Swayimg: "..image.path)
end)

-- vi:ts=4
