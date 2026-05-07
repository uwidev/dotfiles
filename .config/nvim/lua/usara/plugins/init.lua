local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'usara', 'plugins')
for file_name, type in vim.fs.dir(plugins_dir) do
  if type == 'file' and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('usara.plugins.' .. module)
  end
end
