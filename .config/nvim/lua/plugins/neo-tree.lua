return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
    config = function()
      -- 快捷键：打开或切换文件树
      vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { desc = "File Explorer" })

      require("neo-tree").setup({
        close_if_last_window = true, -- 当只剩 Neo-tree 时自动关闭
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,

        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      })
    end,
  }
}
