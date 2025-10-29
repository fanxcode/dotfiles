#!/bin/zsh
setopt NULL_GLOB

# 指定目录，默认当前目录
DIR=${1:-.}

# 遍历视频文件
find "$DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.flv" \) | while read -r f; do
  echo "🎬 $f"

  ffprobe -v error -select_streams v:0 \
    -show_entries stream=codec_name,width,height,pix_fmt \
    -show_entries format=duration \
    -of default=noprint_wrappers=1:nokey=1 "$f" | awk -v size="$(du -h "$f" | cut -f1)" '
      NR==1{codec=$0} NR==2{width=$0} NR==3{height=$0} NR==4{pix=$0} NR==5{duration=$0}
      END{
        bitdepth = (pix ~ /10/ ? "10bit" : (pix ~ /12/ ? "12bit" : "8bit"))
        h=int(duration/3600); m=int((duration%3600)/60); s=int(duration%60)
        timestr = (h>0 ? sprintf("%02d:%02d:%02d",h,m,s) : sprintf("%02d:%02d",m,s))
        printf "   %s | %sx%s | %s | %s | %s\n", codec, width, height, bitdepth, timestr, size
      }'
done
