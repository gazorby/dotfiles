vim.loader.enable()

require("globals")

require("options")

require("mappings")

require("plugin_specs")

-- after plugin_specs, since nvim-lspconfig and fzf-lua are loaded in that step
require("lsp_conf")

require("diagnostic-conf")

require("ui")
