return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			-- Install parsers if missing
			local parsers = {
				"lua",
				"c",
				"c_sharp",
				"typescript",
				"javascript",
				"tsx",
				"html",
				"css",
				"json",
				"yaml",
				"bash",
				"python",
			}
			require("nvim-treesitter").install(parsers)

			-- Enable highlighting + folding per filetype
			-- (map parser name -> filetypes Neovim uses)
			local ft_map = {
				lua = "lua",
				c = "c",
				c_sharp = "cs",
				typescript = "typescript",
				javascript = "javascript",
				tsx = "typescriptreact",
				html = "html",
				css = "css",
				json = "json",
				yaml = "yaml",
				bash = "sh",
				python = "python",
			}
			local filetypes = vim.tbl_values(ft_map)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetypes,
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
					vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo.foldmethod = "expr"
					vim.wo.foldenable = false -- don't auto-fold on open; remove if you like folds closed
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")
			local swap = require("nvim-treesitter-textobjects.swap")

			-- Select
			local sel_map = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["ai"] = "@conditional.outer",
				["ii"] = "@conditional.inner",
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
			}
			for key, query in pairs(sel_map) do
				vim.keymap.set({ "x", "o" }, key, function()
					select.select_textobject(query, "textobjects")
				end, { desc = "TS select " .. query })
			end

			-- Move
			local function mv(fn, query, desc)
				return function()
					fn(query, "textobjects")
				end, { desc = desc }
			end
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				move.goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]c", function()
				move.goto_next_start("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]a", function()
				move.goto_next_start("@parameter.inner", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]F", function()
				move.goto_next_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]C", function()
				move.goto_next_end("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[c", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[a", function()
				move.goto_previous_start("@parameter.inner", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[F", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[C", function()
				move.goto_previous_end("@class.outer", "textobjects")
			end)

			-- Swap
			vim.keymap.set("n", "<leader>a", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap next param" })
			vim.keymap.set("n", "<leader>A", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Swap prev param" })
		end,
	},
}
