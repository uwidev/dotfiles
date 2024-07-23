-- Function to get the selected or motion text
local function get_selected_text(mode)
	local start_pos, end_pos
	start_pos = vim.fn.getpos "'<"
	end_pos = vim.fn.getpos "'>"

	-- Empty selecltion
	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	if #lines == 0 then
		return ''
	end

	-- Correct for end pos on visual line, since goes huge on visual line select
	local real_end_pos_col = vim.fn.col { end_pos[2], '$' }
	if end_pos[3] > real_end_pos_col then
		end_pos[3] = real_end_pos_col
	end

	-- Adjust the start and end positions to include only the selected text
	if mode == 'v' then
		lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
		lines[1] = string.sub(lines[1], start_pos[3], -1)
	end

	return table.concat(lines, '\n'), start_pos, end_pos
end

function simple_refactor(mode)
	local selected_text, start_pos, end_pos = get_selected_text()

	if selected_text == '' then
		print 'No text selected'
		return
	end

	local path = vim.fn.input 'New file path: '
	if path == '' then
		print 'File path is required'
		return
	end

	local file_name_ext = path:match '([^/]+)$'
	local file_name = path:match '([^/.]+)[^/]*$'
	local file_dir = path:match '$(/?.*)'

	if file_dir == nil or file_dir == '' then
		file_dir = vim.api.nvim_buf_get_name(0):match '^(/?.*)/'
	end

	local save_path = file_dir .. '/' .. file_name_ext

	-- Write the selected text to the new file
	local file = io.open(save_path, 'w')
	file:write(selected_text)
	file:close()

	-- Replace the selected text with the wiki-like link
	-- Vim uses 0-based columns and rows, but lua uses 1-based indexing
	-- Vim is also end-column inclusive
	local link_text = '{:' .. file_name .. ':}'
	-- print(start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3] - 1)
	vim.api.nvim_buf_set_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3] - 1, { link_text })
	vim.cmd 'normal =='

	-- vim.fn.setline(start_pos[2], link_text)
	--
	-- -- Delete the rest of the selected lines if necessary
	-- if end_pos[2] > start_pos[2] then
	--   vim.fn.setline(start_pos[2] + 1, {})
	--   vim.fn.deletebufline(vim.fn.bufnr(), start_pos[2] + 1, end_pos[2])
	-- end

	-- Open the new file in a new window buffer
	vim.cmd('vsplit ' .. save_path)
end

return {
	simple_refactor = simple_refactor,
}
