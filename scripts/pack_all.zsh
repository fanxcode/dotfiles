#!/usr/bin/env zsh

# 打包当前目录下的所有文件和文件夹
for item in *; do
  # 跳过非文件或文件夹的情况
  [[ -e "$item" ]] || continue
  
  # 生成随机的8位字母数字
  random_name=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8)
  
  # 打包成tar文件
  tar -cf "${random_name}.tar" "$item"
  
  echo "✅ 已打包: $item -> ${random_name}.tar"
done
