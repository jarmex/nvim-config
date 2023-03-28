require("config.options")
-- require("filetypes")
-- require("os")
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.autocmds")
    require("config.keymaps")
  end
})
require("config.lazy")