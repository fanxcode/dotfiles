#!/usr/bin/env zsh
set -euo pipefail

# ---------- 处理单个视频文件 ----------
process_video() {
  local infile="$1"
  local dir="${infile:h}"
  local base="${infile:t:r}"
  local outfile="${dir}/${base}_hevc.mp4"

  echo "转码: $infile → $outfile"

  ffmpeg -hide_banner -loglevel error -y -nostdin \
    -i "$infile" \
    -c:v hevc_videotoolbox -q:v 60 -tag:v hvc1 -profile:v main \
    "$outfile"
}

# ---------- 主逻辑 ----------
target="${1:-.}"

if [[ -d "$target" ]]; then
  # 安全处理目录下所有视频文件
  find "$target" -type f \( -iname "*.mov" -o -iname "*.mp4" -o -iname "*.m4v" -o -iname "*.3gp" -o -iname "*.wmv" -o -iname "*.avi" -o -iname "*.mkv" \) -print0 |
    while IFS= read -r -d '' f; do
      process_video "$f"
    done
else
  # 单文件
  process_video "$target"
fi
