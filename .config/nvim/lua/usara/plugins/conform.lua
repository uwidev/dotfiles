vim.pack.add { gh 'stevearc/conform.nvim' }
require('conform').setup {
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- You can specify filetypes to autoformat on save here:
		local enabled_filetypes = {
			-- lua = true,
			-- python = true,
		}
		if enabled_filetypes[vim.bo[bufnr].filetype] then
			return { timeout_ms = 500 }
		else
			return nil
		end
	end,
	default_format_opts = {
		lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
	},
	formatters_by_ft = {
		lua = { 'stylua' },
		-- Conform can also run multiple formatters sequentially
		python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
		--
		-- You can use a sub-list to tell conform to run *until* a formatter
		-- is found.
		-- javascript = { { "prettierd", "prettier" } },
		c = { 'clang-format' },
	},
}

vim.keymap.set({ 'n', 'v' }, '<leader>ff', function()
	require('conform').format { async = true }
end, { desc = '[f]ormat bu[f]fer' })
