-- Python debugging: nvim-dap + debugpy, with a UI and inline variable values.
--
--   <leader>Db  toggle breakpoint        <F9>   toggle breakpoint
--   <leader>DB  conditional breakpoint   <F5>   continue / start
--   <leader>Dc  continue / start         <F10>  step over
--   <leader>Di  step into                <F11>  step into
--   <leader>Do  step over                <F12>  step out
--   <leader>DO  step out
--   <leader>Dt  terminate                <leader>Du  toggle debug UI
--   <leader>Dl  re-run last              <leader>Dr  open the debug REPL
--   <leader>De  evaluate (word / selection)
--   <leader>Dm  debug test method        <leader>DM  debug test class (pytest)
--   <leader>Ds  debug selection (visual)
--
-- debugpy is installed by Mason (see `tools` in lsp.lua). It runs in its own venv
-- and starts your program with the interpreter of the project venv: $VIRTUAL_ENV,
-- $CONDA_PREFIX, or a .venv / venv folder in the working directory.
-- For custom launch settings (args, env, justMyCode = false) add a
-- .vscode/launch.json in the project; nvim-dap picks it up.
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
      "mfussenegger/nvim-dap-python",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: continue / start" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },

      { "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      {
        "<leader>DB",
        function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        desc = "Conditional breakpoint",
      },
      { "<leader>Dc", function() require("dap").continue() end, desc = "Continue / start" },
      { "<leader>Di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>Do", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>DO", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>Dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>Dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>Dr", function() require("dap").repl.toggle() end, desc = "Debug REPL" },
      { "<leader>Du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
      { "<leader>De", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Evaluate" },

      -- pytest (nvim-dap-python)
      { "<leader>Dm", function() require("dap-python").test_method() end, desc = "Debug test method" },
      { "<leader>DM", function() require("dap-python").test_class() end, desc = "Debug test class" },
      { "<leader>Ds", function() require("dap-python").debug_selection() end, mode = "v", desc = "Debug selection" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      -- Open the UI when a session starts, close it when it ends
      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      -- Gutter signs (colours follow the colourscheme's diagnostic groups)
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "CursorLine" })

      -- debugpy from Mason, falling back to a system python that has debugpy
      local mason_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local adapter_python = vim.uv.fs_stat(mason_python) and mason_python or "python3"
      require("dap-python").setup(adapter_python)
      require("dap-python").test_runner = "pytest"
    end,
  },
}
