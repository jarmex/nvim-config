---@diagnostic disable: need-check-nil
--TODO: work in progress
--https://github.com/nazo6/nvim/blob/master/lua/user/plugins/lsp/lspconfig/attach.lua


local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

local function rename()
  if pcall(require, "inc_rename") then
    vim.api.nvim_feedkeys(":IncRename " .. vim.fn.expand("<cword>"), "n", false)
  else
    vim.lsp.buf.rename()
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ctx)
    local map = vim.keymap.set
    local client = vim.lsp.get_client_by_id(ctx.data.client_id)
    assert(client, "No client found")
    local bufnr = ctx.buf

    if client.name == "copilot" then
      return
    end

    if client.name == "gopls" then
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = semantic.tokenTypes,
            tokenModifiers = semantic.tokenModifiers,
          },
          range = true,
        }
      end
    end


    if client.name == "ruff_lsp" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end


    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = bufnr, desc = "[LSP] Go implementation" })
    map("n", "gy", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[LSP] Go declaration" })
    map("n", "gd", "<cmd>Glance definitions<CR>", { buffer = bufnr, desc = "[LSP] Go definitions" })
    map("n", "gr", "<cmd>Glance references<CR>", { buffer = bufnr, desc = "[LSP] Go references" })
    map("n", "gI", "<cmd>Glance implementations<CR>", { buffer = bufnr, desc = "[LSP] Go implementation" })
    map("n", "gt", "<cmd>Glance type_definitions<cr>", { desc = "Goto Type Definition" })

    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = bufnr, desc = "[LSP] Hover" })
    map(
      { "n", "i" },
      "<C-s>",
      "<cmd>lua vim.lsp.buf.signature_help()<CR>",
      { buffer = bufnr, desc = "[LSP] Signature help" }
    )

    map(
      "n",
      "gl",
      "<cmd>lua vim.diagnostic.open_float(0,{border='rounded'})<CR>",
      { buffer = bufnr, desc = "[LSP] Show diagnostics" }
    )

    map("n", "[d", diagnostic_goto(true), { desc = "Next Diagnostic" })
    map("n", "]d", diagnostic_goto(false), { desc = "Next Diagnostic" })

    map(
      "n",
      "<leader>q",
      "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",
      { buffer = bufnr, desc = "[LSP] Set loclist" }
    )
    map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = bufnr })
    map("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = bufnr })
    map("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { buffer = bufnr })


    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "[C]ode [A]ctions" })
    -- map({ "n", "v" }, "<leader>fd", format, { desc = "[F]ormat Document" })
    map("n", "<leader>ci", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
    map("n", "<leader>ch", vim.lsp.codelens.refresh, { desc = "CodeLens Refresh" })
    map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "[C]ode[L]ens Run" })
    map("n", "<leader>cr", rename, { desc = "[R]ename" })

    map('n', '<leader>lu', function()
      return require('telescope.builtin').lsp_references({
        previewer = false,
        fname_width = (vim.o.columns * 0.4),
      })
    end, { desc = 'LSP references' })
  end,
})
