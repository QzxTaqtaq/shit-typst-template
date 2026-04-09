#!/bin/bash

# 检测操作系统并设置数据目录
OS_TYPE="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="Linux"
    DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macOS"
    DATA_DIR="$HOME/Library/Application Support"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    OS_TYPE="Windows"
    DATA_DIR="$APPDATA"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo "Detected OS: $OS_TYPE"
TARGET_DIR="$DATA_DIR/typst/packages/local"

PACKAGE_NAME="shit-template"

# 检测 local 目录是否存在
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Creating directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

PACKAGE_DIR="$TARGET_DIR/shit-template"
if [[ -z "$VERSION" ]]; then
    VERSION="0.1.0" # 如果读取失败的默认值
fi

# 最终安装的具体版本目录
VERSION_DIR="$PACKAGE_DIR/$VERSION"

# 如果已存在则删除旧的，确保是纯净安装
if [[ -d "$VERSION_DIR" ]]; then
    echo "Removing existing version: $VERSION_DIR"
    rm -rf "$VERSION_DIR"
fi

echo "Creating directory: $VERSION_DIR"
mkdir -p "$VERSION_DIR"


echo "Copying files to $VERSION_DIR"
# 排除掉 .git 等隐藏文件
cp -r ./* "$VERSION_DIR/" 2>/dev/null

echo "Operation completed."
echo -e "\033[32m安装成功！你可以使用以下代码进行调用：\033[0m"
echo -e "\033[33m#import \"@local/shit-template:0.1.0\": *\033[0m"