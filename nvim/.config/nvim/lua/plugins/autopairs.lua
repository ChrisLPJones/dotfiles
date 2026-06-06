return {
  "windwp/nvim-autopairs",
  config = function()
    require("nvim-autopairs").setup({
      check_ts = true,  -- integrate with treesitter for smarter pairing
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    })
  end
}
