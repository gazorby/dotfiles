local dap = require("dap")
local widgets = require("dap.ui.widgets")
local map = vim.keymap.set

-- debugpy-adapter comes from `uv tool install debugpy`
dap.adapters.debugpy = { type = "executable", command = "debugpy-adapter" }

local function python_path()
  local venv = os.getenv("VIRTUAL_ENV") or vim.fn.getcwd() .. "/.venv"
  if vim.fn.executable(venv .. "/bin/python") == 1 then
    return venv .. "/bin/python"
  end
  return vim.fn.exepath("python3")
end

dap.configurations.python = {
  {
    type = "debugpy",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    console = "integratedTerminal",
    pythonPath = python_path,
  },
  {
    type = "debugpy",
    request = "launch",
    name = "Launch module",
    module = function() return vim.fn.input("Module: ") end,
    console = "integratedTerminal",
    pythonPath = python_path,
  },
  {
    type = "debugpy",
    request = "launch",
    name = "Pytest current file",
    module = "pytest",
    args = { "${file}" },
    console = "integratedTerminal",
    pythonPath = python_path,
  },
  {
    type = "debugpy",
    request = "attach",
    name = "Attach (localhost:5678)",
    connect = { host = "127.0.0.1", port = 5678 },
  },
}

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

map("n", "<F5>", dap.continue, { desc = "Debug continue" })
map("n", "<F10>", dap.step_over, { desc = "Debug step over" })
map("n", "<F11>", dap.step_into, { desc = "Debug step into" })
map("n", "<F12>", dap.step_out, { desc = "Debug step out" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "[D]ebug [B]reakpoint" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "[D]ebug conditional [B]reakpoint" })
map("n", "<leader>dl", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
end, { desc = "[D]ebug [L]og point" })
map("n", "<leader>dc", dap.continue, { desc = "[D]ebug [C]ontinue" })
map("n", "<leader>dC", dap.run_to_cursor, { desc = "[D]ebug run to [C]ursor" })
map("n", "<leader>dL", dap.run_last, { desc = "[D]ebug run [L]ast" })
map("n", "<leader>dr", dap.repl.toggle, { desc = "[D]ebug [R]EPL" })
map("n", "<leader>dt", dap.terminate, { desc = "[D]ebug [T]erminate" })
map({ "n", "v" }, "<leader>dh", widgets.hover, { desc = "[D]ebug [H]over" })
map("n", "<leader>df", function() widgets.centered_float(widgets.frames) end, { desc = "[D]ebug [F]rames" })
map("n", "<leader>ds", function() widgets.centered_float(widgets.scopes) end, { desc = "[D]ebug [S]copes" })
