autoload -Uz compinit
compinit
# nvim 文件补全（排除不适合编辑的文件类型）
_nvim_filtered_complete() {

  # 补全前缀
  local prefix="$PREFIX*"

  # 不适合编辑的扩展名（黑名单）
  local -a exclude_exts
  exclude_exts=(
    '*.png' '*.jpg' '*.jpeg' '*.gif' '*.webp'
    '*.mp4' '*.mov' '*.mkv' '*.avi'
    '*.pdf'
    '*.zip' '*.tar' '*.gz' '*.7z'
    '*.dmg' '*.iso'
  )

  # 找当前前缀匹配的所有文件
  local -a files
  files=(${~prefix}(N))

  # 排除黑名单中的文件
  for ex in $exclude_exts; do
    files=(${files:#$~ex})
  done

  # 添加补全结果
  compadd -- $files
}

# 将 nvim 的补全部署为自定义函数
compdef _nvim_filtered_complete nvim 
