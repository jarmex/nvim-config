local icons = require("settings").icons.diagnostics

--------------------------------------------------------------------------------------

local function dapConfig()
  vim.fn.sign_define("DapStopped", { text = icons.Stopped, texthl = "DiagnosticHint", linehl = "DapPause" })
  vim.fn.sign_define("DapBreakpoint", { text = icons.Breakpoint, texthl = "DiagnosticInfo", linehl = "DapBreak" })
  vim.fn.sign_define("DapBreakpointRejected", { text = icons.BreakpointRejected, texthl = "DiagnosticError" })

  -- AUTO-OPEN/CLOSE THE DAP-UI
  local listener = require("dap").listeners.before
  listener.attach.dapui_config = function() require("dapui").open() end
  listener.launch.dapui_config = function() require("dapui").open() end
  listener.event_terminated.dapui_config = function() require("dapui").close() end
  listener.event_exited.dapui_config = function() require("dapui").close() end

  require("plugins.debugger.typescript")
end

return {
  --  DEBUGGER ----------------------------------------------------------------
  --  Debugger alternative to vim-inspector [debugger]
  --  https://github.com/mfussenegger/nvim-dap
  --  Here we configure the adapter+config of every debugger.
  --  Debuggers don't have system dependencies, you just install them with mason.
  --  We currently ship most of them with nvim.
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      {
        "<leader>db",
        function() require("dap").toggle_breakpoint() end,
        desc = "Toggle Breakpoint"
      },
      {
        "<leader>dc",
        function() require("dap").continue() end,
        desc = "Continue"
      },
      {
        "<leader>dC",
        function() require("dap").run_to_cursor() end,
        desc = "Run to Cursor"
      },
      { "<leader>ds", function() require("dap").continue() end, desc = "Start" },
      {
        "<leader>dg",
        function() require("dap").goto_() end,
        desc = "Go to line (no execute)"
      },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
        desc = "Breakpoint Condition"
      },
      { "<leader>dj", function() require("dap").down() end,     desc = "Down" },
      {
        "<leader>dw",
        function() require("dap.ui.widgets").hover() end,
        desc = "Widgets"
      },
      { "<leader>dE", "<cmd>lua require('dapui').eval(vim.fn.input '[Expression] > ')<cr>", desc = "Evaluate Input" },
      { "<leader>dO", "<cmd>lua require('dap').step_out()<CR>",                             desc = "Step Out" },
      { "<leader>dP", "<cmd>lua require('dapui').float_element()<cr>",                      desc = "Float Element" },
      { "<leader>dR", "<cmd>lua require('dap').run_to_cursor()<cr>",                        desc = "Run to Cursor" },
      { "<leader>dS", function() require("dap.ui.widgets").scopes() end,                    desc = "Scopes", },
      { "<leader>dd", "<cmd>lua require('dap').disconnect()<cr>",                           desc = "Disconnect" },
      { "<leader>dg", function() require("dap").session() end,                              desc = "Get Session", },
      { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>",                     desc = "Hover Variables" },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end,                     desc = "Hover Variables", },
      { "<leader>di", "<cmd>lua require('dap').step_into()<CR>",                            desc = "Step Into" },
      { "<leader>dl", function() require("dap").run_last() end,                             desc = "Run Last" },
      { "<leader>do", "<cmd>lua require('dap').step_over()<CR>",                            desc = "Step Over" },
      { "<leader>dp", "<cmd>lua require('dap').pause()<cr>",                                desc = "Pause" },
      { "<leader>dq", function() require("dap").close() end,                                desc = "Quit", },
      { "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>",                            desc = "Toggle REPL" },
      { "<leader>dt", function() require("dap").toggle_breakpoint() end,                    desc = "Terminate" },
      { "<leader>dv", "<cmd>lua require('dap.ui.widgets').preview()<cr>",                   desc = "Preview" },
      { "<leader>dx", "<cmd>lua require('dap').terminate()<cr>",                            desc = "Terminate" },
    },

    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = 'eol' }, },
    },

    config = dapConfig,
  },


  { -- fancy UI for the debugger
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>dI", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      {
        "<leader>dl",
        ---@diagnostic disable-next-line: missing-fields
        function() require("dapui").float_element("breakpoints", { enter = true }) end,
        desc = " List Breakpoints",
      },
      {
        "<leader>de",
        function()
          -- Calling this twice to open and jump into the window.
          require('dapui').eval()
          require('dapui').eval()
        end,
        mode = { "n", "v" },
        desc = "Evaluate expression"
      },
    },
    opts = {
      icons = { expanded = "▾", collapsed = "▸" },
      -- floating = { border = 'rounded' },
      layouts = {
        {
          elements = {
            -- { id = 'stacks',      size = 0.30 },
            -- { id = 'breakpoints', size = 0.20 },
            { id = 'scopes',  size = 0.50 },
            { id = 'watches', size = 0.50 },
          },
          position = 'right',
          size = 40,
        },
        {
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 }
          },
          position = "bottom",
          size = 10
        }
      },
      floating = {
        border = vim.g.borderStyle,
        -- max_height = 0.5,
        -- max_width = 0.9,
        -- border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      render = {
        max_type_length = nil,
      },
    },
  },

  { -- mason.nvim integration
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,
      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},
      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    },
  },
  --  Debugging with go debugger
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Debug (Main) Package",
            request = "launch",
            program = "main.go",
            cwd = '${workspaceFolder}',
          },
        },
      })
    end
  },
}


-- credit
-- check this out https://github.com/mawkler/nvim/blob/master/lua/configs/dap.lua
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugins/debugger.lua
-- https://github.com/NormalNvim/NormalNvim/blob/main/lua/plugins/4-dev.lua
