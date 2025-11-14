#!/usr/bin/env python3
import os
import sys
import subprocess
import concurrent.futures
import shlex
from pathlib import Path

# 支持的视频扩展
VIDEO_EXTS = {".mp4", ".mkv", ".mov", ".avi", ".flv", ".3gp"}

def human_size(size):
    for unit in ["B", "KB", "MB", "GB", "TB"]:
        if size < 1024:
            return f"{size:.1f}{unit}"
        size /= 1024
    return f"{size:.1f}PB"

def safe_path(path: Path) -> str:
    """返回对终端安全的相对路径（使用shell转义）"""
    try:
        rel = path.relative_to(Path.cwd())
    except ValueError:
        rel = path
    return shlex.quote(str(rel))

def get_info(path: Path) -> str:
    """调用 ffprobe 获取视频信息"""
    try:
        cmd = [
            "ffprobe", "-v", "error", "-select_streams", "v:0",
            "-show_entries", "stream=codec_name,width,height,pix_fmt",
            "-show_entries", "format=duration",
            "-of", "default=noprint_wrappers=1:nokey=1", str(path)
        ]
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=5)
        lines = result.stdout.strip().split("\n")

        if len(lines) < 5:
            return f"⚠️  {safe_path(path)} | 无法解析"

        codec, width, height, pix, duration = lines[:5]
        bitdepth = "10bit" if "10" in pix else "12bit" if "12" in pix else "8bit"

        duration = float(duration)
        h = int(duration // 3600)
        m = int((duration % 3600) // 60)
        s = int(duration % 60)
        timestr = f"{h:02d}:{m:02d}:{s:02d}" if h > 0 else f"{m:02d}:{s:02d}"

        size = human_size(path.stat().st_size)

        return f"🎬 {safe_path(path)} | {codec} | {width}x{height} | {bitdepth} | {timestr} | {size}"
    except Exception as e:
        return f"⚠️  {safe_path(path)} | 错误: {e}"

def main():
    sys.stdout.reconfigure(line_buffering=True)  # 让输出实时可grep
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
    files = [
        p for p in root.rglob("*")
        if p.suffix.lower() in VIDEO_EXTS and ".Trashes" not in p.parts
    ]

    print(f"📂 共发现 {len(files)} 个视频文件\n")

    max_workers = os.cpu_count() or 8
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as ex:
        for result in ex.map(get_info, files):
            print(result)

if __name__ == "__main__":
    main()
