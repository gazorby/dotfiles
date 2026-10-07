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

-- Most-recently-used tab cycling. WezTerm cannot see Ctrl being released, so
-- presses less than this many seconds apart walk further back in one cycle.
local MRU_CYCLE_TIMEOUT = 0.3
local mru_by_window = {}
local cycle_by_window = {}

local function now()
  return tonumber(wezterm.time.now():format '%s%.3f')
end

local function promote_active_tab(window)
  local tab = window:active_tab()
  if not tab then
    return
  end
  local tab_id = tab:tab_id()
  local mru = mru_by_window[window:window_id()] or {}
  for i, id in ipairs(mru) do
    if id == tab_id then
      table.remove(mru, i)
      break
    end
  end
  table.insert(mru, 1, tab_id)
  mru_by_window[window:window_id()] = mru
end

local function mru_tabs(window)
  local live = {}
  local tabs = window:mux_window():tabs()
  for _, tab in ipairs(tabs) do
    live[tab:tab_id()] = tab
  end
  local ordered, ids = {}, {}
  local function add(tab)
    if live[tab:tab_id()] then
      table.insert(ordered, tab)
      table.insert(ids, tab:tab_id())
      live[tab:tab_id()] = nil
    end
  end
  for _, id in ipairs(mru_by_window[window:window_id()] or {}) do
    if live[id] then
      add(live[id])
    end
  end
  for _, tab in ipairs(tabs) do
    add(tab)
  end
  mru_by_window[window:window_id()] = ids
  return ordered
end

local function cycle_expired(cycle)
  return not cycle or now() - cycle.last_press >= MRU_CYCLE_TIMEOUT
end

wezterm.on('update-status', function(window)
  local window_id = window:window_id()
  if cycle_expired(cycle_by_window[window_id]) then
    cycle_by_window[window_id] = nil
    promote_active_tab(window)
  end
end)

local activate_mru_tab = wezterm.action_callback(function(window)
  local window_id = window:window_id()
  local cycle = cycle_by_window[window_id]
  if cycle_expired(cycle) then
    promote_active_tab(window)
    cycle = { tabs = mru_tabs(window), index = 1, last_press = now() }
    cycle_by_window[window_id] = cycle
  end
  if #cycle.tabs < 2 then
    return
  end
  cycle.index = cycle.index % #cycle.tabs + 1
  cycle.last_press = now()
  cycle.tabs[cycle.index]:activate()
end)

-- keybindings
config.keys = {
  -- Scrollback
  { key = 'PageUp', mods = 'ALT', action = act.ScrollByPage(-0.5) },
  { key = 'PageDown', mods = 'ALT', action = act.ScrollByPage(0.5) },
  -- Opt+Up/Down go to line start/end
  { key = 'UpArrow', mods = 'OPT', action = act.SendKey { key = 'Home' } },
  { key = 'DownArrow', mods = 'OPT', action = act.SendKey { key = 'End' } },
  -- Cmd+Backspace deletes to line start
  { key = 'Backspace', mods = 'SUPER', action = act.SendKey { key = 'u', mods = 'CTRL' } },
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
  { key = 'Tab', mods = 'CTRL', action = activate_mru_tab },
  -- Pipe character on French keyboard
  { key = 'l', mods = 'ALT|SHIFT', action = act.SendString '|' },
  -- Tilde on French keyboard
  { key = 'n', mods = 'OPT', action = act.SendString '~' },
  -- Backslash on French keyboard
  { key = '/', mods = 'ALT|SHIFT', action = act.SendString '\\' },
}

return config
