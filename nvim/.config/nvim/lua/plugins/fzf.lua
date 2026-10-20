return {
	"ibhagwan/fzf-lua",
	version = "*",
	dependencies = {},
	config = function()
		local fzf = require("fzf-lua")
		-- Example: define a custom highlight group for the fzf border
		-- you can change fg/bg to whatever hex values you want
		vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = "#3b4261", bg = "NONE" })
		vim.api.nvim_set_hl(0, "FzfLuaNormal", { fg = nil, bg = "#14141a" })
		vim.api.nvim_set_hl(0, "FzfLuaTitle", { fg = "#c6a0f6", bold = true })
		fzf.setup({
			winopts = {
				fullscreen = true,
				preview = {
					layout = "vertical",
					vertical = "up:70%",
				},
				-- use `hls` (plural). Map fzf window parts to Neovim highlight groups.
				-- border / normal / title / preview_border are common keys.
				hls = {
					border = "FzfLuaBorder", -- the border highlight group
					normal = "FzfLuaNormal", -- window background / text group
					title = "FzfLuaTitle", -- title text (if shown)
					preview_border = "FzfLuaBorder", -- preview pane border
				},
			},
			files = {
				-- Include hidden and gitignored files, but skip .git and node_modules
				-- (fd is used when installed, otherwise rg)
				fd_opts = "--color=never --type f --type l --hidden --no-ignore --exclude .git --exclude node_modules",
				rg_opts = '--color=never --files --hidden --no-ignore -g "!.git" -g "!node_modules"',
				fzf_opts = {
					["--exact"] = "",
					["--no-sort"] = "",
				},
			},
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
			diagnostics = {
				cwd_only = false,
				file_icons = false,
				git_icons = false,
				color_headings = true,
				diag_icons = true,
				diag_source = true,
				diag_code = true,
				icon_padding = "",
				multiline = 2,
			},
			-- Show kind text only (no icons)
			lsp = {
				symbols = {
					symbol_style = 3, -- 3 = kind text only (no icon prefix)
				},
			},
		})
		-- keep fzf border highlight after colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				-- reapply your custom highlights (or compute from the new colorscheme)
				vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = "#3b4261", bg = "NONE" })
				vim.api.nvim_set_hl(0, "FzfLuaNormal", { fg = nil, bg = "#14141a" })
				vim.api.nvim_set_hl(0, "FzfLuaTitle", { fg = "#c6a0f6", bold = true })
			end,
		})
		fzf.register_ui_select()

		vim.keymap.set("n", "<M-f>", fzf.files, { desc = "Find files" })
		vim.keymap.set("n", "<M-b>", fzf.buffers, { desc = "Buffers (ctrl-x to delete)" })
		vim.keymap.set("n", "<M-g>", fzf.live_grep, { desc = "Live grep" })
	end,
}
