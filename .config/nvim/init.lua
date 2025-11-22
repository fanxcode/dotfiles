require("config.lazy")
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'sourcekit'
vim.lsp.enable 'clangd'
vim.lsp.enable 'ruff'

require("config.options")
require("config.keymaps")
vim.cmd.colorscheme "catppuccin"

