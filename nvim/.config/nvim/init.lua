vim.filetype.add({
	extension = {
		razor = "razor",
		cshtml = "razor",
	},
})
-- Enable Lua bytecode caching for faster startup
vim.loader.enable()

vim.opt.cmdheight = 1
vim.opt.textwidth = 0
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"

-- Use OSC52 over SSH/headless (no display server); native provider otherwise
if not (vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY) then
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			["*"] = require("vim.ui.clipboard.osc52").paste("*"),
		},
	}
end
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.path:append({ "**" })
vim.opt.signcolumn = "yes"
vim.api.nvim_set_keymap("n", "<leader>tb", ":botright split | term<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "y", '"+y', { noremap = true, silent = true })
vim.keymap.set("n", "Y", '"+Y', { noremap = true, silent = true })

vim.opt.scrolloff = 999

-- Persistent undo
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Reduce disk I/O
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = false

-- Faster updates
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Filetype-specific settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = "c",
	callback = function()
		vim.bo.tabstop = 4
		vim.bo.shiftwidth = 4
		vim.bo.expandtab = true
	end,
})

-- lazy.nvim setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- Mason registry setup (after lazy is loaded)
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})
