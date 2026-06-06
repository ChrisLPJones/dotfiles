return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	config = function()
		local wk = require("which-key")
		wk.setup({
			plugins = {
				marks = true,
				registers = true,
				spelling = { enabled = false },
				presets = {
					operators = true,
					motions = true,
					text_objects = true,
					windows = true,
					nav = true,
					z = true,
					g = true,
				},
			},
			icons = {
				breadcrumb = ">",
				separator = "-",
				group = "+",
			},
			win = {
				border = "rounded",
				padding = { 1, 2 },
			},
			layout = {
				height = { min = 4, max = 25 },
				width = { min = 20, max = 50 },
				spacing = 3,
			},
			show_help = true,
			show_keys = true,
		})

		-- Register key groups
		wk.add({
			{ "<leader>c", group = "Code" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>h", group = "Git Hunks" },
			{ "<leader>r", group = "Rename" },
			{ "<leader>t", group = "Toggle" },
		})
	end,
}
