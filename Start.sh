#!/bin/bash

# 解析参数文件，跳过注释行（以 # 开头的行）
while IFS='=' read -r key value; do
    if [[ $key == "RAMX" ]]; then
        RAMX=$value
    elif [[ $key == "RAMS" ]]; then
        RAMS=$value
    elif [[ $key == "WAIT_TIME" ]]; then
        WAIT_TIME=$value
    elif [[ $key == "CUSTOM_PARAMS" ]]; then
        CUSTOM_PARAMS=$value
    elif [[ $key == "JAR_FILE" ]]; then
        JAR_FILE=$value
    elif [[ $key == "JAVA_PATH" ]]; then
        JAVA_PATH=$value
    fi
done < startup_parameter.txt

# 检查 RAMX 和 RAMS 是否为空，增加条件判断的安全性
if [ -z "$RAMX" ]; then
    echo "[错误] RAMX 参数未设置！请检查 startup_parameter.txt。"
    exit 1
fi

if [ -z "$RAMS" ]; then
    echo "[错误] RAMS 参数未设置！请检查 startup_parameter.txt。"
    exit 1
fi

if [ -z "$WAIT_TIME" ]; then
    WAIT_TIME=3
fi

if [ -z "$CUSTOM_PARAMS" ]; then
    CUSTOM_PARAMS=""
fi

if [ -z "$JAVA_PATH" ]; then
    JAVA_PATH="java"
fi

if [ -z "$JAR_FILE" ]; then
    echo "[错误] JAR_FILE 参数未设置！请检查 startup_parameter.txt。"
    exit 1
fi

# 获取系统最大可用内存
SYS_MAX_RAM=$(free -m | awk 'NR==2{print $2}')

# 打印服务器信息
echo "============================================"
echo "       欢迎使用 Minecraft 服务器启动器"
echo "--------------------------------------------"
echo "   分配最大内存 (RAMX) ：$RAMX"
echo "   分配最小内存 (RAMS) ：$RAMS"
echo "   最大可用内存   ：$SYS_MAX_RAM MB"
echo "   崩溃重启等待时间：$WAIT_TIME 秒"
echo "   其他启动参数   ：$CUSTOM_PARAMS"
echo "   使用的 JAR 文件 ：$JAR_FILE"
echo "============================================"

# 等待用户确认
read -p "按任意键继续..."

# 启动 Minecraft 服务器
while true; do
    echo "[启动] 正在启动 Minecraft 服务器..."
    $JAVA_PATH -Xms$RAMS -Xmx$RAMX $CUSTOM_PARAMS -jar $JAR_FILE nogui

    echo "[警告] 服务器意外崩溃！将在 $WAIT_TIME 秒后重启..."
    sleep $WAIT_TIME
done