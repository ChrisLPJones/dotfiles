
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",       -- DAP UI
			"nvim-neotest/nvim-nio",      -- REQUIRED for nvim-dap-ui
			"williamboman/mason.nvim",    -- Mason package manager
			"jay-babu/mason-nvim-dap.nvim", -- Mason integration for DAP
		},
		config = function()
			local ok, dap = pcall(require, "dap")
			if not ok then
				vim.notify("nvim-dap not found", vim.log.levels.ERROR)
				return
			end

			local dapui = require("dapui")

			------------------------------------------------------
			-- Mason DAP setup (Mason itself is configured in init.lua)
			------------------------------------------------------
			require("mason-nvim-dap").setup({
				ensure_installed       = { "codelldb", "netcoredbg", "debugpy" },
				automatic_installation = true,
			})

			------------------------------------------------------
			-- DAP UI setup
			------------------------------------------------------
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			------------------------------------------------------
			-- C / C++ Debugging (codelldb)
			------------------------------------------------------
			local mason_path    = vim.fn.stdpath("data") .. "/mason/packages/codelldb"
			local adapter_path  = mason_path .. "/extension/adapter/codelldb"
			local liblldb_path  = mason_path .. "/extension/lldb/lib/liblldb.so"
			local sysname       = vim.loop.os_uname().sysname

			if sysname == "Darwin" then
				liblldb_path = mason_path .. "/extension/lldb/lib/liblldb.dylib"
			elseif sysname:match("Windows") then
				adapter_path = mason_path .. "\\extension\\adapter\\codelldb.exe"
				liblldb_path = mason_path .. "\\extension\\lldb\\bin\\liblldb.dll"
			end

			dap.adapters.codelldb = {
				type       = "server",
				port       = "${port}",
				executable = {
					command = adapter_path,
					args    = { "--port", "${port}" },
					env     = { LLDB_LIBRARY_PATH = liblldb_path },
				},
			}

			dap.configurations.c = {
				{
					name        = "Launch current file (C)",
					type        = "codelldb",
					request     = "launch",
					program     = function()
						local file   = vim.fn.expand("%:p")
						local output = vim.fn.expand("%:r")
						vim.fn.system(string.format("gcc -g -O0 -o %s %s", output, file))
						if vim.v.shell_error ~= 0 then
							vim.notify("❌ Compilation failed!", vim.log.levels.ERROR)
							return nil
						end
						return output
					end,
					cwd         = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.cpp = dap.configurations.c

			------------------------------------------------------
			-- C# Debugging (netcoredbg)
			------------------------------------------------------
			local netcoredbg = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg"
			dap.adapters.coreclr = {
				type    = "executable",
				command = netcoredbg,
				args    = { "--interpreter=vscode" },
			}

			dap.configurations.cs = {
				{
					type        = "coreclr",
					name        = "Launch .NET (External Terminal)",
					request     = "launch",
					program     = function()
						local cwd  = vim.fn.getcwd()
						local dlls = vim.fn.glob(cwd .. "/bin/Debug/net*/*.dll", 0, 1)

						if #dlls == 0 then
							vim.notify("❌ No DLL found. Run `dotnet build` first.", vim.log.levels.ERROR)
							return vim.fn.input("Path to DLL: ", cwd .. "/", "file")
						end

						if #dlls > 1 then
							local choices = {}
							for i, path in ipairs(dlls) do
								table.insert(choices, string.format("%d. %s", i, path))
							end
							local choice = vim.fn.inputlist(vim.list_extend({ "Select DLL to debug:" }, choices))
							if choice < 1 or choice > #dlls then
								vim.notify("❌ Invalid choice.", vim.log.levels.ERROR)
								return nil
							end
							return dlls[choice]
						end

						return dlls[1]
					end,
					cwd         = "${workspaceFolder}",
					stopAtEntry = true,
					console     = "externalTerminal",
				},
			}

			------------------------------------------------------
			-- Python Debugging (debugpy)
			------------------------------------------------------
			local debugpy_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			dap.adapters.python = {
				type    = "executable",
				command = debugpy_path,
				args    = { "-m", "debugpy.adapter" },
			}

			dap.configurations.python = {
				{
					type        = "python",
					request     = "launch",
					name        = "Launch file",
					program     = "${file}",
					pythonPath  = function()
						local venv = os.getenv("VIRTUAL_ENV")
						if venv then
							return venv .. "/bin/python"
						end
						return "python3"
					end,
				},
			}

			------------------------------------------------------
			-- Keymaps
			------------------------------------------------------
			local map = vim.keymap.set
			map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
			map("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "DAP: Conditional Breakpoint" })
			map("n", "<leader>dp", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { desc = "DAP: Log Point" })
			map("n", "<leader>dc", dap.continue,         { desc = "DAP: Continue" })
			map("n", "<leader>di", dap.step_into,        { desc = "DAP: Step Into" })
			map("n", "<leader>do", dap.step_out,         { desc = "DAP: Step Out" })
			map("n", "<leader>dn", dap.step_over,        { desc = "DAP: Step Over" })
			map("n", "<leader>dr", dap.repl.open,        { desc = "DAP: Open REPL" })
			map("n", "<leader>dl", dap.run_last,         { desc = "DAP: Run Last" })
			map("n", "<leader>dq", dap.terminate,        { desc = "DAP: Quit Debugging" })
			map("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP: Toggle UI" })
		end,
	},
}

