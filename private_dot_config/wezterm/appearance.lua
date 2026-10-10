local wezterm = require 'wezterm' ---@type Wezterm
local theme = require 'theme'

local M = {}

-- WezTerm has no window-created event, so maximize each window on its first status update
local maximized_windows = {}

wezterm.on('update-status', function(window)
  local window_id = window:window_id()
  if not maximized_windows[window_id] then
    maximized_windows[window_id] = true
    window:maximize()
  end
end)

function M.apply_to_config(config)
  config.font = wezterm.font 'MonoLisa Nerd Font'
  config.font_size = 13
  config.color_schemes = theme.schemes
  config.color_scheme = theme.scheme_for_appearance()

  config.initial_cols = 120
  config.initial_rows = 28

  config.scrollback_lines = 15000

  config.switch_to_last_active_tab_when_closing_tab = true
  config.adjust_window_size_when_changing_font_size = false
  config.audible_bell = 'Disabled'
  config.window_close_confirmation = 'NeverPrompt'
end

return M
