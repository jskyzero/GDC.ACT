#!/bin/bash

# 1. 设置配置 (可以通过环境变量覆盖)
: "${SOURCE_DIR:="../design.jskyzero.com"}"       # 源仓库目录
: "${FILE_NAME:="2023-11-13-ACT_with_GDC.md"}"    # 源文件名
: "${TARGET_MD:="slides.md"}"                     # Slidev 需要的入口文件名
: "${PUBLIC_DIR:="./public"}"                     # Slidev 的静态资源目录

# 2. 清理旧数据
echo "清理旧目录..."
rm -f "$TARGET_MD"
rm -rf "$PUBLIC_DIR"
mkdir -p "$PUBLIC_DIR"

# 3. 查找并拷贝主文档为 slides.md
echo "正在查找 $FILE_NAME ..."
found_file=$(find "$SOURCE_DIR" -name "$FILE_NAME" | head -n 1)

if [ -z "$found_file" ]; then
    echo "错误: 未能在 $SOURCE_DIR 中找到文件 $FILE_NAME"
    exit 1
fi

# 拷贝并重命名为 slides.md
cp "$found_file" "./$TARGET_MD"
echo "已生成: ./$TARGET_MD"

# 4. 扫描 slides.md 中的图片并拷贝到 public 目录
# 使用 grep 提取 ![](/assets/...) 里的路径
# 注意：Slidev 渲染时会将 public 映射到 /，所以 /assets/... 会指向 public/assets/...
grep -oP '!\[.*?\]\(\K[^)]+(?=\))' "./$TARGET_MD" | while read -r img; do
    
    # 去掉路径最前面的 / (如果有的话)，方便在文件系统查找
    clean_img_path="${img#/}"
    
    # 物理源路径
    src_img_path="$SOURCE_DIR/$clean_img_path"
    
    # 物理目标路径 (必须在 public 目录下)
    target_img_path="$PUBLIC_DIR/$(dirname "$clean_img_path")"

    # 执行拷贝
    if [[ -f "$src_img_path" ]]; then
        mkdir -p "$target_img_path"
        cp "$src_img_path" "$target_img_path/"
        echo "已同步资产: $clean_img_path"
    else
        echo "警告: 找不到资产文件: $src_img_path"
    fi
done

echo "---------------------------------------"
echo "所有文件准备就绪！"
echo "现在可以运行: npm run dev"