return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000, -- load before other plugins so their highlight tweaks aren't wiped
  config = function()
    vim.cmd.colorscheme("kanagawa-wave")
    vim.api.nvim_set_hl(0, "Normal", { bg = "#14141a" })  -- Set to your desired color
  end,
}
