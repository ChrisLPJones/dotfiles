return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"ibhagwan/fzf-lua", -- Add this if not already there
		{
			"seblyng/roslyn.nvim",
			commit = "f2ec6ee",
		},
		{
			"tris203/rzls.nvim",
		},
	},
	config = function()
		--------------------------------------------------------
		-- Faster CursorHold (diagnostics popup)
		--------------------------------------------------------
		vim.o.updatetime = 300
		local util = require("lspconfig.util")
		--------------------------------------------------------
		-- Capabilities (nvim-cmp support)
		--------------------------------------------------------
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
		if ok then
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
		end
		--------------------------------------------------------
		-- on_attach (LSP keymaps)
		--------------------------------------------------------
		local function on_attach(client, bufnr)
			local map = vim.keymap.set
			local opts = { buffer = bufnr, silent = true, noremap = true }

			-- Go to definition
			map("n", "gd", vim.lsp.buf.definition, opts)

			-- Peek definition (keeps current window)
			map("n", "gp", function()
				vim.lsp.buf.definition({ reuse_win = true })
			end, opts)

			-- Document symbols (FIXED - use fzf-lua which handles encoding properly)
			map("n", "gs", function()
				require("fzf-lua").lsp_document_symbols()
			end, opts)

			-- References (use fzf-lua for consistency)
			map("n", "gr", function()
				require("fzf-lua").lsp_references()
			end, opts)

			-- Type definitions
			map("n", "gy", function()
				require("fzf-lua").lsp_typedefs()
			end, opts)

			-- Implementations
			map("n", "gi", function()
				require("fzf-lua").lsp_implementations()
			end, opts)

			-- Hover documentation
			map("n", "K", vim.lsp.buf.hover, opts)

			-- Signature help
			map("n", "<C-k>", vim.lsp.buf.signature_help, opts)

			-- Rename symbol
			map("n", "<leader>rn", vim.lsp.buf.rename, opts)

			-- Code actions (use fzf-lua for better UI)
			map("n", "<leader>ca", function()
				require("fzf-lua").lsp_code_actions()
			end, opts)
		end
		--------------------------------------------------------
		-- Helper: register & enable servers
		--------------------------------------------------------
		local function setup(server, opts)
			vim.lsp.config(server, opts)
			vim.lsp.enable(server)
		end
		--------------------------------------------------------
		-- Lua
		--------------------------------------------------------
		setup("lua_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					format = {
						enable = true,
						defaultConfig = {
							indent_style = "space",
							indent_size = 2,
						},
					},
					telemetry = { enable = false },
					hint = {
						enable = true,
						semicolon = "Disable",
					},
					codeLens = {
						enable = true,
					},
				},
			},
		})
		--------------------------------------------------------
		-- C / C++
		--------------------------------------------------------
		-- Add offsetEncoding capability for clangd
		local clangd_capabilities = vim.deepcopy(capabilities)
		clangd_capabilities.offsetEncoding = { "utf-8", "utf-16" }

		setup("clangd", {
			on_attach = on_attach,
			capabilities = clangd_capabilities,
			cmd = {
				"clangd",
				"--fallback-style=Microsoft",
				"--clang-tidy",
				"--completion-style=detailed",
			},
		})
		--------------------------------------------------------
		-- C# (Roslyn)
		--------------------------------------------------------
		setup("roslyn", {
			on_attach = on_attach,
			capabilities = capabilities,
			broad_search = true,
			filewatching = "auto",
			lock_target = false,
			silent = false,
		})
		--------------------------------------------------------
		-- TypeScript / JavaScript
		--------------------------------------------------------
		setup("ts_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
			root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json"),
		})
		--------------------------------------------------------
		-- Python
		--------------------------------------------------------
		setup("pyright", {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
					},
				},
			},
		})
		--------------------------------------------------------
		-- HTML
		--------------------------------------------------------
		setup("html", {
			on_attach = on_attach,
			capabilities = capabilities,
			filetypes = { "html" },
			root_dir = util.root_pattern("package.json", ".git", "index.html"),
			settings = {
				html = {
					format = {
						wrapLineLength = 120,
						unformatted = "pre,code,textarea",
					},
					hover = {
						documentation = true,
						references = true,
					},
				},
			},
			init_options = {
				provideFormatter = true,
			},
		})
		--------------------------------------------------------
		-- Diagnostics UI (FIXED - using new API)
		--------------------------------------------------------
		vim.diagnostic.config({
			virtual_text = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = " ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				focus = false,
				scope = "line",
				border = "rounded",
			},
		})

		-- Auto-show diagnostics on cursor hold
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				vim.diagnostic.open_float()
			end,
		})
	end,
}
