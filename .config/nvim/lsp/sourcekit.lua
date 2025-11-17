return {
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { 'utf-8', 'utf-16' },
  },

  cmd = { 'sourcekit-lsp' },

  filetypes = { 'swift' },

  root_markers = {
    'Package.swift',
    '.git',
  },

  single_file_support = false,
}
