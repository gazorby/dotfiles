-- Machine-local SSH domains: chezmoi creates this file once and never overwrites it.
local wezterm = require 'wezterm' ---@type Wezterm

local domains = wezterm.default_ssh_domains()

-- table.insert(domains, {
--   name = 'devbox',
--   remote_address = 'devbox.example.com',
--   username = 'me',
--   multiplexing = 'WezTerm',
-- })

return domains
