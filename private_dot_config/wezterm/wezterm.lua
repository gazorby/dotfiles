local wezterm = require 'wezterm' ---@type Wezterm

require 'status'

local config = wezterm.config_builder()

require('appearance').apply_to_config(config)
require('keys').apply_to_config(config)

return config
