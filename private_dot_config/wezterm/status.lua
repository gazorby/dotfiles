local wezterm = require 'wezterm' ---@type Wezterm

wezterm.on('update-status', function(window)
  local key_table = window:active_key_table()
  if not key_table then
    window:set_left_status ''
    return
  end
  window:set_left_status(wezterm.format {
    { Foreground = { AnsiColor = 'Black' } },
    { Background = { AnsiColor = 'Yellow' } },
    ---@diagnostic disable-next-line: missing-fields
    { Attribute = { Intensity = 'Bold' } },
    { Text = ' ' .. key_table:upper() .. ' ' },
  })
end)
