return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
        heading = {
            enabled = true,
            sign = true,
            icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " }, -- H1–H6 icons
            width = "block", -- highlight width matches text, not full line
            backgrounds = {
                "RenderMarkdownH1Bg",
                "RenderMarkdownH2Bg",
                "RenderMarkdownH3Bg",
                "RenderMarkdownH4Bg",
                "RenderMarkdownH5Bg",
                "RenderMarkdownH6Bg",
            },
        },
        code = {
            enabled = true,
            sign = true,
            style = "full", -- full = background + border on code blocks
            width = "block",
            border = "thick",
            left_pad = 2,
            right_pad = 2,
        },
        bullet = {
            enabled = true,
            icons = { "●", "○", "◆", "◇" }, -- nested list bullets
        },
        checkbox = {
            enabled = true,
            unchecked = { icon = "󰄱 " },
            checked = { icon = "󰱒 " },
        },
        quote = {
            enabled = true,
            icon = "▋",
        },
        pipe_table = {
            enabled = true,
            style = "full", -- render tables with nice borders
        },
        link = {
            enabled = true,
            image = "󰥶 ",
            hyperlink = "󰌷 ",
        },
    },
}
