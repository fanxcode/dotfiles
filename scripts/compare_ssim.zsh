#!/usr/bin/env zsh

# 用法：
#   compare_ssim.zsh video1.mp4 video2.mp4
# 输出：
#   SSIM、PSNR 的平均值等结果

set -e

if [[ $# -ne 2 ]]; then
  echo "用法: $0 <原视频> <压缩视频>"
  exit 1
fi

v1="$1"
v2="$2"

# 检查文件是否存在
if [[ ! -f "$v1" || ! -f "$v2" ]]; then
  echo "❌ 文件不存在"
  exit 1
fi

echo "🎬 比较中..."
ffmpeg -hide_banner -i "$v1" -i "$v2" \
-filter_complex "[0:v]settb=AVTB[v0];[1:v]settb=AVTB[v1];
[v0][v1]ssim=stats_file=/tmp/ssim.log;
[v0][v1]psnr=stats_file=/tmp/psnr.log" \
-f null - 2>&1 | tee /tmp/compare.log | grep -E "SSIM|PSNR"

echo "\n📊 平均结果："
grep "All:" /tmp/compare.log | awk '{print $3, $4, $5, $6}'
