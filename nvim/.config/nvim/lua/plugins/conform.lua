return {
	"stevearc/conform.nvim",
	version = "*",
	dependencies = {},
	config = function()
		-- Add .NET tools (CSharpier) to PATH
		vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.expand("~") .. "/.dotnet/tools"

		local conform = require("conform")

		conform.setup({
			-- Map filetypes to formatters (keys must match `formatters` table)
			formatters_by_ft = {
				cs = { "csharpier" }, -- C#
				c = { "clang_format" }, -- C
				cpp = { "clang_format" }, -- C++
				lua = { "stylua" }, -- Lua
				python = { "isort", "black" }, -- Python
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				["*"] = { "trim_whitespace" }, -- fallback
			},

			-- Define formatters
			formatters = {
				csharpier = {
					command = "csharpier",
					args = {
						"format",
					},
					stdin = true,
				},
				clang_format = {
					command = "clang-format",
					args = { "--assume-filename", "$FILENAME" },
					stdin = true,
				},
				stylua = {
					command = "stylua",
					args = { "-" },
					stdin = true,
				},
				black = {
					command = "black",
					args = { "-" },
					stdin = true,
				},
				isort = {
					command = "isort",
					args = { "-" },
					stdin = true,
				},
				prettier = {
					command = "prettier",
					args = { "--stdin-filepath", "$FILENAME" },
					stdin = true,
				},
				trim_whitespace = {
					command = "sed",
					args = { "s/[[:space:]]*$//" },
					stdin = true,
				},
			},

			default_format_opts = {
				lsp_format = "fallback",
				quiet = false,
				stop_after_first = false,
				timeout_ms = 2000,
			},

			format_on_save = {
				timeout_ms = 2000,
				lsp_format = "fallback",
			},

			log_level = vim.log.levels.INFO,
			notify_on_error = true,
			notify_no_formatters = true,
		})

		-- Map <leader>f to format buffer
		vim.keymap.set("n", "<leader>f", function()
			conform.format({ bufnr = 0 })
		end, { desc = "Format current buffer", noremap = true, silent = true })
	end,
}
