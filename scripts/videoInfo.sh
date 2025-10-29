setopt NULL_GLOB

# 指定目录，默认当前目录
DIR=${1:-.}

# 遍历视频文件
find "$DIR" -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.flv" \) | while read -r f; do
  echo "🎬 $f"

  # 获取编码、分辨率和色深
  ffprobe -v error -select_streams v:0 \
    -show_entries stream=codec_name,width,height,pix_fmt \
    -of default=noprint_wrappers=1:nokey=1 "$f" | awk 'NR==1{codec=$0} NR==2{width=$0} NR==3{height=$0} NR==4{pix=$0} END{
      bitdepth = (pix ~ /10/ ? "10bit" : (pix ~ /12/ ? "12bit" : "8bit"))
      printf "   Codec: %s | Resolution: %sx%s | Color Depth: %s\n", codec, width, height, bitdepth
    }'
done
