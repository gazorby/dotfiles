-- Pull in the wezterm API
local wezterm = require 'wezterm'

local act = wezterm.action
local config = wezterm.config_builder()

-- How many lines of scrollback you want to retain per tab
config.scrollback_lines = 15000

-- Geometry
config.initial_cols = 120
config.initial_rows = 28

-- Theme
config.font_size = 13
config.color_scheme = 'Monokai Pro (Gogh)'

-- keybindings
config.keys = {
  -- Scrollback
  { key = 'PageUp', mods = 'ALT', action = act.ScrollByPage(-0.5) },
  { key = 'PageDown', mods = 'ALT', action = act.ScrollByPage(0.5) },
  { key = 'X', mods = 'SUPER', action = wezterm.action.ActivateCopyMode },
  -- Copy mode
  {
    key = 'C',
    mods = 'SUPER',
    action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection',
  },
  -- Cycle tabs
  { key = 'LeftArrow', mods = 'ALT|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'ALT|SHIFT', action = act.ActivateTabRelative(1) },
  -- Pipe character on French keyboard
  { key = 'l', mods = 'ALT|SHIFT', action = act.SendString '|' },
  -- Tilde on French keyboard
  { key = 'n', mods = 'OPT', action = act.SendString '~' },
  -- Backslash on French keyboard
  { key = '/', mods = 'ALT|SHIFT', action = act.SendString '\\' },
}

return config
