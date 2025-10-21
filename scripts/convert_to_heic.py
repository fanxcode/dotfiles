#!/usr/bin/env python3

import os
import subprocess
import sys
import shlex
from concurrent.futures import ThreadPoolExecutor

def convert_to_heic(input_path, output_path):
    """将单个图片文件转换为 HEIC 格式"""
    # 使用shlex.quote来处理路径中的特殊字符
    input_path_quoted = shlex.quote(input_path)
    output_path_quoted = shlex.quote(output_path)
    
    cmd = f'/usr/bin/sips -s format heic {input_path_quoted} --out {output_path_quoted}'
    subprocess.run(cmd, shell=True, check=True)

def process_file(file_path):
    """处理单个文件，转换为 HEIC 格式并删除原文件"""
    if file_path.lower().endswith(('.jpg', '.jpeg', '.png', '.tiff', '.bmp', '.webp')):
        output_path = f"{os.path.splitext(file_path)[0]}.heic"
        convert_to_heic(file_path, output_path)
        os.remove(file_path)  # 删除原文件
        print(f"转换完成并删除原文件: {file_path}")

def process_files(input_path):
    """处理文件或目录"""
    files_to_process = []
    
    if os.path.isfile(input_path):
        # 如果是文件，直接添加到待处理文件列表
        files_to_process.append(input_path)
    elif os.path.isdir(input_path):
        # 如果是目录，遍历目录中的所有文件
        for root, dirs, files in os.walk(input_path):
            for file in files:
                files_to_process.append(os.path.join(root, file))
    else:
        print("输入路径无效！")
        return

    # 使用 ThreadPoolExecutor 执行并行处理
    with ThreadPoolExecutor() as executor:
        executor.map(process_file, files_to_process)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("请提供要转换的文件或目录路径！")
        sys.exit(1)
    
    input_path = sys.argv[1]
    process_files(input_path)
