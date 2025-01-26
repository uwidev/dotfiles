return {
	{ -- nvim-dap debug adaptor protocol
		'mfussenegger/nvim-dap',
		lazy = false,
		keys = {
			{ '<F5>', "<cmd>lua require('dap').continue()<cr>", 'n', desc = 'Debug continue' },
			{ '<F10>', "<cmd>lua require('dap').step_over()<cr>", 'n', desc = 'Debug step over' },
			{ '<F11>', "<cmd>lua require('dap').step_into()<cr>", 'n', desc = 'Debug step into' },
			{ '<F12>', "<cmd>lua require('dap').step_out()<cr>", 'n', desc = 'Debug step out' },
			{ '<leader>b', "<cmd>lua require('dap').toggle_breakpoint()<cr>", 'n', desc = 'Debug toggle breakpoint' },
			{ '<leader>B', "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Break condition: '))<cr>", 'n', desc = 'Debug set conditional breakpoint' },
			{ '<leader>dr', "<cmd>lua require('dap').repl.open()<cr>", 'n', desc = 'Inspect' },
			{ '<leader>dl', "<cmd>lua require('dap').repl.run_last()<cr>", 'n', desc = 'Rerun last debugging session' },
		},
		config = function()
			local dap = require 'dap'

			vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
			vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })

			dap.adapters.gdb = {
				type = 'executable',
				command = 'gdb',
				args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
			}
			dap.configurations.c = {
				{
					name = 'Launch',
					type = 'gdb',
					request = 'launch',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
					stopAtBeginningOfMainSubprogram = true,
					args = { '/home/timmy/in/swayimg_anchor_test/200x200.png' },
				},
				{
					name = 'Select and attach to process',
					type = 'gdb',
					request = 'attach',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					pid = function()
						local name = vim.fn.input 'Executable name (filter): '
						return require('dap.utils').pick_process { filter = name }
					end,
					cwd = '${workspaceFolder}',
				},
				{
					name = 'Attach to gdbserver :1234',
					type = 'gdb',
					request = 'attach',
					target = 'localhost:1234',
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = '${workspaceFolder}',
				},
			}
		end,
	},
	{ -- nvim-dap-ui
		'rcarriga/nvim-dap-ui',
		dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
	},
}
