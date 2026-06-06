return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			local actions = require("telescope.actions")
			--------------------------------------------------
			-- Telescope setup
			--------------------------------------------------
			telescope.setup({
				defaults = {
					hidden = true,
					no_ignore = true,
					file_ignore_patterns = { "node_modules" },
					layout_strategy = "vertical",
					layout_config = {
						width = 0.95,
						height = 0.95,
						prompt_position = "top",
						preview_height = 0.6,
						preview_cutoff = 1,
						mirror = true,
					},
					sorting_strategy = "ascending",
					prompt_prefix = "🔍 ",
					selection_caret = "> ",
					entry_prefix = "  ",
					initial_mode = "insert",
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					-- Performance optimizations
					preview = {
						treesitter = true,
					},
					-- Auto select first result immediately
					selection_strategy = "reset",
				},
				pickers = {
					buffers = {
						initial_mode = "normal",
						sort_lastused = true,
						sort_mru = true,
						mappings = {
							n = {
								["dd"] = "delete_buffer",
							},
						},
					},
					live_grep = {
						-- Custom entry maker to show only filename:line without matched text
						entry_maker = function(entry)
							local make_entry = require("telescope.make_entry")
							local default_entry = make_entry.gen_from_vimgrep()(entry)

							-- Override display to show only filename:line:col
							default_entry.display = function(e)
								local display_filename = e.filename
								return string.format("%s:%s:%s", display_filename, e.lnum, e.col)
							end

							return default_entry
						end,
					},
				},
				extensions = {
					["ui-select"] = require("telescope.themes").get_dropdown({
						prompt_prefix = "Select> ",
						initial_mode = "normal",
						sorting_strategy = "ascending",
					}),
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			telescope.load_extension("ui-select")
			telescope.load_extension("fzf")
			--------------------------------------------------
			-- Keymaps
			--------------------------------------------------
			vim.keymap.set("n", "<M-f>", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<M-b>", builtin.buffers, { desc = "Buffers" })

			vim.keymap.set("n", "<M-g>", builtin.live_grep, { desc = "Live grep" })
			--------------------------------------------------
			-- Custom Telescope colors
			--------------------------------------------------
			local function set_telescope_highlights()
				local set_hl = vim.api.nvim_set_hl
				-- Prompt
				set_hl(0, "TelescopePromptNormal", { bg = "#14141a", fg = "NONE" })
				set_hl(0, "TelescopePromptBorder", { bg = "#14141a", fg = "#3b4261" })
				set_hl(0, "TelescopePromptTitle", { bg = "#14141a", fg = "#ff9e64" })
				set_hl(0, "TelescopePromptPrefix", { bg = "#14141a", fg = "#7aa2f7" })
				-- Results
				set_hl(0, "TelescopeResultsNormal", { bg = "#14141a", fg = "NONE" })
				set_hl(0, "TelescopeResultsBorder", { bg = "#14141a", fg = "#3b4261" })
				set_hl(0, "TelescopeResultsTitle", { bg = "#14141a", fg = "#ff9e64" })
				-- Preview
				set_hl(0, "TelescopePreviewNormal", { bg = "#14141a", fg = "NONE" })
				set_hl(0, "TelescopePreviewBorder", { bg = "#14141a", fg = "#3b4261" })
				set_hl(0, "TelescopePreviewTitle", { bg = "#14141a", fg = "#ff9e64" })
				-- Selection - highlighted background
				set_hl(0, "TelescopeSelection", { bg = "#283457", fg = "NONE", bold = true })
				set_hl(0, "TelescopeSelectionCaret", {
					bg = "#283457",
					fg = "#7aa2f7",
					bold = true,
				})
				-- Matching text
				set_hl(0, "TelescopeMatching", { fg = "#ff9e64", bold = true })
				-- Multi select
				set_hl(0, "TelescopeMultiSelection", { fg = "#ff9e64" })
				set_hl(0, "TelescopeMultiIcon", { fg = "#ff9e64" })
				-- Base
				set_hl(0, "TelescopeNormal", { bg = "#14141a", fg = "NONE" })
			end
			--------------------------------------------------
			-- Apply highlights
			--------------------------------------------------
			vim.api.nvim_create_autocmd("ColorScheme", {
				callback = set_telescope_highlights,
			})
			vim.api.nvim_create_autocmd("VimEnter", {
				once = true,
				callback = function()
					vim.defer_fn(set_telescope_highlights, 100)
				end,
			})
		end,
	},
}
