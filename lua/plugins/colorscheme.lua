local M = {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'macchiato',
      transparent_background = true,
      term_colors = true,
      compile = {
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        suffix = "_compiled",
      },
      styles = {
        variables = { "italic" },
        operators = { "italic" },
      },
      integrations = {
        treesitter = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        neotest = true,
        cmp = true,
        gitsigns = true,
        telescope = true,
        nvimtree = true,
        navic = {
          enabled = true,
        },
        mason = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        which_key = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        dashboard = true,
        bufferline = true,
        markdown = true,
        notify = true,
        telekasten = true,
        symbols_outline = true,
      },
      custom_highlights = function(colors)
        return {
          PmenuThumb = { bg = colors.blue },
          DapUIFloatBorder = { link = 'FloatBorder' },
        }
      end,
    },
    config = function(plugin, opt)
      vim.opt.background = 'dark'
      require(plugin.name).setup(opt)
      -- vim.api.nvim_command 'colorscheme catppuccin'
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "css",
        "scss",
        "javascript",
        html = { mode = "background" },
      }, { mode = "foreground" })
    end,
  },
}

return M
