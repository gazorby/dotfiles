local wezterm = require 'wezterm' ---@type Wezterm
local mru_tabs = require 'mru_tabs'

local act = wezterm.action

local M = {}

local VIM_DIRECTIONS = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }

local function pane_keys()
  local keys = {}
  for key, direction in pairs(VIM_DIRECTIONS) do
    table.insert(keys, { key = key, mods = 'SUPER|ALT', action = act.ActivatePaneDirection(direction) })
    table.insert(keys, { key = key, mods = 'SUPER|CTRL', action = act.SplitPane { direction = direction } })
  end
  return keys
end

local function resize_pane_keys()
  local keys = {
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'q', action = 'PopKeyTable' },
  }
  for key, direction in pairs(VIM_DIRECTIONS) do
    table.insert(keys, { key = key, action = act.AdjustPaneSize { direction, 1 } })
  end
  return keys
end

local open_url = act.QuickSelectArgs {
  label = 'open url',
  patterns = {
    '\\((https?://\\S+)\\)',
    '\\[(https?://\\S+)\\]',
    '\\{(https?://\\S+)\\}',
    '<(https?://\\S+)>',
    '\\bhttps?://\\S+[)/a-zA-Z0-9-]+',
  },
  action = wezterm.action_callback(function(window, pane)
    wezterm.open_with(window:get_selection_text_for_pane(pane))
  end),
}

function M.apply_to_config(config)
  local keys = {
    -- Scrollback
    { key = 'PageUp', mods = 'ALT', action = act.ScrollByPage(-0.5) },
    { key = 'PageDown', mods = 'ALT', action = act.ScrollByPage(0.5) },
    { key = 'k', mods = 'SUPER|SHIFT', action = act.ScrollByPage(-0.5) },
    { key = 'j', mods = 'SUPER|SHIFT', action = act.ScrollByPage(0.5) },

    -- Line editing: Opt+Up/Down go to line start/end, Cmd+Backspace deletes to line start
    { key = 'UpArrow', mods = 'ALT', action = act.SendKey { key = 'Home' } },
    { key = 'DownArrow', mods = 'ALT', action = act.SendKey { key = 'End' } },
    { key = 'Backspace', mods = 'SUPER', action = act.SendKey { key = 'u', mods = 'CTRL' } },
    -- Newline without submitting, e.g. in Claude Code
    { key = 'Enter', mods = 'SHIFT', action = act.SendString '\x1b\r' },

    -- Panes
    { key = 'Enter', mods = 'SUPER', action = act.TogglePaneZoomState },
    { key = 'Enter', mods = 'SUPER|SHIFT', action = act.TogglePaneZoomState },
    { key = 'r', mods = 'SUPER|CTRL', action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false, timeout_milliseconds = 1000 } },

    -- Clipboard and copy mode
    { key = 'c', mods = 'SUPER|SHIFT', action = act.CopyTo 'ClipboardAndPrimarySelection' },
    { key = 'x', mods = 'SUPER|SHIFT', action = act.ActivateCopyMode },
    { key = 'u', mods = 'SUPER|CTRL', action = open_url },

    -- Tabs
    { key = 'h', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(-1) },
    { key = 'l', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'CTRL', action = mru_tabs.action },

    -- French keyboard: left Option is Alt, so these characters need explicit binds
    { key = 'l', mods = 'ALT|SHIFT', action = act.SendString '|' },
    { key = 'n', mods = 'ALT', action = act.SendString '~' },
    { key = '/', mods = 'ALT|SHIFT', action = act.SendString '\\' },
  }

  for _, key in ipairs(pane_keys()) do
    table.insert(keys, key)
  end

  config.keys = keys
  config.key_tables = { resize_pane = resize_pane_keys() }
end

return M
