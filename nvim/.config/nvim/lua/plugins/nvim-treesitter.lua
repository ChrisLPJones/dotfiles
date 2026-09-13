return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      init = function()
        -- Avoid clashing with Neovim's built-in ftplugin text-object maps;
        -- we define our own keymaps below.
        vim.g.no_plugin_maps = true
      end,
    },
  },
  config = function()
    local ts = require("nvim-treesitter")

    local ensure_installed = {
      "lua", "c", "c_sharp", "typescript", "javascript", "tsx",
      "html", "css", "json", "yaml", "bash", "python",
      "markdown", "markdown_inline",
    }
    ts.install(ensure_installed)

    -- Install (if needed), highlight, and indent any filetype with an
    -- available parser -- replaces the old highlight/indent/auto_install.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        local ok_available, available = pcall(ts.get_available)
        if not ok_available or not vim.tbl_contains(available, lang) then
          return
        end
        if not vim.tbl_contains(ts.get_installed("parsers"), lang) then
          local ok_install = pcall(function()
            ts.install(lang):wait(30000)
          end)
          if not ok_install then
            return
          end
        end
        pcall(vim.treesitter.start)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Treesitter folding for a curated set of filetypes
    local fold_fts = {
      "lua", "c", "cs", "typescript", "javascript", "typescriptreact",
      "html", "css", "json", "yaml", "sh", "python",
    }
    vim.api.nvim_create_autocmd("FileType", {
      pattern = fold_fts,
      callback = function()
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo.foldmethod = "expr"
        vim.wo.foldenable = false
      end,
    })

    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    local select_textobject = require("nvim-treesitter-textobjects.select").select_textobject
    local select_keymaps = {
      af = "@function.outer", ["if"] = "@function.inner",
      ac = "@class.outer", ic = "@class.inner",
      aa = "@parameter.outer", ia = "@parameter.inner",
      ai = "@conditional.outer", ii = "@conditional.inner",
      al = "@loop.outer", il = "@loop.inner",
    }
    for lhs, query in pairs(select_keymaps) do
      vim.keymap.set({ "x", "o" }, lhs, function()
        select_textobject(query, "textobjects")
      end, { desc = "Select " .. query })
    end

    local swap = require("nvim-treesitter-textobjects.swap")
    vim.keymap.set("n", "<leader>a", function()
      swap.swap_next("@parameter.inner")
    end, { desc = "Swap next @parameter.inner" })
    vim.keymap.set("n", "<leader>A", function()
      swap.swap_previous("@parameter.inner")
    end, { desc = "Swap previous @parameter.inner" })

    local move = require("nvim-treesitter-textobjects.move")
    local move_keymaps = {
      { "]f", move.goto_next_start, "@function.outer" },
      { "]c", move.goto_next_start, "@class.outer" },
      { "]a", move.goto_next_start, "@parameter.inner" },
      { "]F", move.goto_next_end, "@function.outer" },
      { "]C", move.goto_next_end, "@class.outer" },
      { "[f", move.goto_previous_start, "@function.outer" },
      { "[c", move.goto_previous_start, "@class.outer" },
      { "[a", move.goto_previous_start, "@parameter.inner" },
      { "[F", move.goto_previous_end, "@function.outer" },
      { "[C", move.goto_previous_end, "@class.outer" },
    }
    for _, m in ipairs(move_keymaps) do
      local lhs, fn, query = m[1], m[2], m[3]
      vim.keymap.set({ "n", "x", "o" }, lhs, function()
        fn(query, "textobjects")
      end, { desc = "Goto " .. query })
    end
  end,
}
