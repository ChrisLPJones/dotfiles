return {
  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({})
      vim.keymap.set("n", "<M-Left>", "<Cmd>NvimTmuxNavigateLeft<CR>", {})
      vim.keymap.set("n", "<M-Down>", "<Cmd>NvimTmuxNavigateDown<CR>", {})
      vim.keymap.set("n", "<M-Up>", "<Cmd>NvimTmuxNavigateUp<CR>", {})
      vim.keymap.set("n", "<M-Right>", "<Cmd>NvimTmuxNavigateRight<CR>", {})
    end,
  },
}
