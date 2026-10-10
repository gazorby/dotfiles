-- Opens delta's file links (file://<path>#<line>) in helix, in a new tab.
-- A login shell gives helix the same PATH as an interactive session, so its LSPs resolve.
local wezterm = require 'wezterm' ---@type Wezterm

local act = wezterm.action

wezterm.on('open-uri', function(window, pane, uri)
  local path, line = uri:match '^file://(.-)#(%d+)$'
  if not path then
    return
  end
  window:perform_action(
    act.SpawnCommandInNewTab {
      args = { os.getenv 'SHELL' or 'fish', '-lc', 'hx ' .. wezterm.shell_quote_arg(path .. ':' .. line) },
    },
    pane
  )
  return false
end)
