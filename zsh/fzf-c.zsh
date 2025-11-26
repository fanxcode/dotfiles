# =================================================================
# FZF macOS 优化配置：最终修复 (使用数组安全展开参数)
# =================================================================

# 1. 定义核心排除目录的参数【数组】
# 必须使用数组，以确保 Shell 能够将其展开为独立的参数
FZF_EXCLUDE_ARGS=(
  --exclude .git
  --exclude Library/Containers
  --exclude "Library/Group Containers"
  --exclude "Library/Daemon Containers"
)

# 2. 独立 FZF 搜索 (fzf 或 Ctrl-T)
# 使用双引号和数组下标 "${FZF_EXCLUDE_ARGS[@]}" 安全展开参数
_fzf_default_command() {
  echo "fd --type f --hidden ${FZF_EXCLUDE_ARGS[@]}"
}

# 导出变量，确保 fzf 主程序能够调用
export FZF_DEFAULT_COMMAND="$(_fzf_default_command)"


# 3. 路径补全函数 (_fzf_compgen_path, _fzf_compgen_dir)
# 同样使用双引号和数组下标 "${FZF_EXCLUDE_ARGS[@]}"
_fzf_compgen_path() {
  fd --hidden --follow "${FZF_EXCLUDE_ARGS[@]}" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow "${FZF_EXCLUDE_ARGS[@]}" . "$1"
}

# =================================================================``
