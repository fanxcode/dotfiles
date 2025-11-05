require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" },
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- 定义 LSP 配置（新 API）
vim.lsp.config["lua_ls"] = {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
}

-- 启动服务器
vim.lsp.start(vim.lsp.config["lua_ls"])
