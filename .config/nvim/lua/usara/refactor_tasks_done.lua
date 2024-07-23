-- Function to append completed tasks to a '-done' file and delete them from the buffer
local function refactor_tasks_done()
	-- Get the current buffer and its lines
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	-- Get the current buffer's filename
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if bufname == '' then
		print 'Buffer has no name. Please save the buffer before running this command.'
		return
	end

	-- Construct the new filename by appending '-done' before the extension
	local done_filename = bufname:gsub('(%..+)$', '-done%1')
	if done_filename == bufname then
		done_filename = bufname .. '-done'
	end

	-- Open the '-done' file for appending
	local file = io.open(done_filename, 'a')
	if not file then
		print('Could not open ' .. done_filename .. ' for writing')
		return
	end

	-- Collect completed tasks and their line numbers
	local completed_tasks = {}
	local completed_line_numbers = {}

	for i, line in ipairs(lines) do
		if line:match '^%s*%-+ %(x%)' then
			table.insert(completed_tasks, line)
			table.insert(completed_line_numbers, i)
		end
	end

	-- Append completed tasks to the file
	for _, task in ipairs(completed_tasks) do
		file:write(task .. '\n')
	end

	-- Close the file
	file:close()

	-- Delete completed tasks from the buffer (in reverse order to avoid shifting line numbers)
	for i = #completed_line_numbers, 1, -1 do
		vim.api.nvim_buf_set_lines(bufnr, completed_line_numbers[i] - 1, completed_line_numbers[i], false, {})
	end

	print('Completed tasks have been extracted to ' .. done_filename .. '.')
end

-- Map the function to a command in Neovim
vim.api.nvim_create_user_command('RefactorDoneTasks', refactor_tasks_done, {})
