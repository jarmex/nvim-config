return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          -- package_pending = "➜",
          package_pending = "⟳",
          package_uninstalled = "✗"
        }
      },
      ensure_installed = {
        "codelldb",
        "css-lsp",
        "emmet-ls",
        "eslint-lsp",
        "eslint_d",
        "gopls",
        "html-lsp",
        "js-debug-adapter",
        "json-lsp",
        "lua-language-server",
        "luacheck",
        "prettier",
        "prettierd",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylelint-lsp", --CSS
        "stylua",
        "taplo",
        "typescript-language-server",
        "yaml-language-server",
        "yamllint",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  }
}
