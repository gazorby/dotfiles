-- Workspaces cannot tell windows apart: the GUI only shows the active one, so
-- names are kept per mux window in GLOBAL, which survives config reloads.
local wezterm = require 'wezterm' ---@type Wezterm

local M = {}

local function key(mux_window_id)
  return 'window_name_' .. mux_window_id
end

local function name_of(mux_window_id)
  return wezterm.GLOBAL[key(mux_window_id)]
end

wezterm.on('format-window-title', function(tab)
  local name = name_of(tab.window_id)
  local title = tab.active_pane.title
  return name and string.format('[%s] %s', name, title) or title
end)

wezterm.on('update-status', function(window)
  local name = name_of(window:mux_window():window_id())
  window:set_right_status(name and wezterm.format {
    { Foreground = { AnsiColor = 'Purple' } },
    ---@diagnostic disable-next-line: missing-fields
    { Attribute = { Intensity = 'Bold' } },
    { Text = ' ' .. name .. ' ' },
  } or '')
end)

M.rename_action = wezterm.action.PromptInputLine {
  description = 'Window name (empty to clear)',
  action = wezterm.action_callback(function(window, _, line)
    if line then
      wezterm.GLOBAL[key(window:mux_window():window_id())] = line ~= '' and line or nil
    end
  end),
}

return M
