vim.pack.add { gh 'mbbill/undotree' }

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[u]ndo tree' })
