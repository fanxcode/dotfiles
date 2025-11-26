# =================================================================
# FZF macOS 优化配置：排除 Library/Containers 沙盒路径
# 
# 依赖工具：fd (安装：brew install fd)
# =================================================================

### 1. 独立 FZF 搜索 (fzf 或 Ctrl-T)
# 设置 FZF 默认命令：使用 fd 替代 find，排除 .git 和 Library/Containers
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git --exclude Library/Containers --exclude /Library/Daemon\ Containers'

### 2. 路径补全 (在命令行中按 Tab 键)

# 文件和目录路径补全函数 (fzf_compgen_path)
_fzf_compgen_path() {
  # 使用 fd 替代 find，排除 Library/Containers 目录
  # --follow 用于跟随符号链接
  fd --hidden --follow --exclude .git --exclude Library/Containers --exclude /Library/Daemon\ Containers . "$1"
}

# 仅目录补全函数 (fzf_compgen_dir)
_fzf_compgen_dir() {
  # 使用 fd 替代 find，排除 Library/Containers 目录，并只列出目录 (type d)
  fd --type d --hidden --follow --exclude .git --exclude Library/Containers --exclude /Library/Daemon\ Containers --type d . "$1"
}

# =================================================================
