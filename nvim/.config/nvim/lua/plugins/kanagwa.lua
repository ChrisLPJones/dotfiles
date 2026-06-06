return {
  "rebelot/kanagawa.nvim",
  config = function()
    vim.cmd.colorscheme("kanagawa-wave")
    vim.api.nvim_set_hl(0, "Normal", { bg = "#14141a" })  -- Set to your desired color
  end,
}
