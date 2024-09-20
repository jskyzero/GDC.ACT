#!/bin/bash

# 设置要扫描的目录和目标目录
SOURCE_DIR="../design.jskyzero.com"  # 源目录
TARGET_DIR="./output"   # 目标目录
FILE_NAME="2023-11-13-ACT_with_GDC.md" # 要查找的文件名

# 创建目标目录
rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

# 查找指定文件名的文本文档
find "$SOURCE_DIR" -name "$FILE_NAME" | while read -r file; do
    # 复制文本文档到目标目录
    cp "$file" "$TARGET_DIR/"

    relative_path="${file#$SOURCE_DIR}"  # 获取相对路径
    # echo $relative_path


    # 读取文件中的图片链接
    grep -oP '!\[\]\(\K[^)]+(?=\))' "$file" | while read -r img; do
        # 获取图片的相对路径
        img_path="$SOURCE_DIR/$img"
        # 计算目标路径
        target_img_path="$TARGET_DIR/$(dirname "$img")"

        # 创建目标目录
        mkdir -p "$target_img_path"
        
        # 复制图片到目标目录
        if [[ -f "$img_path" ]]; then
            cp "$img_path" "$target_img_path/"
            echo "复制图片: $img_path 到 $target_img_path/"
        else
            echo "警告: 图片未找到: $img_path"
        fi
    done
done

echo "所有文件和图片复制完成！"