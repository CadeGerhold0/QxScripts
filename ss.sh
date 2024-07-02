#!/bin/bash

# 随机生成密码
PASSWORD=$(openssl rand -base64 12)

# 设置 V2Ray 配置
V2RAY_CONFIG='{
  "inbounds": [{
    "port": 1080,
    "listen": "127.0.0.1",
    "protocol": "socks",
    "settings": {
      "auth": "noauth",
      "udp": false,
      "ip": "127.0.0.1"
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  }]
}'

# 设置 Shadowsocks 配置
SS_CONFIG='{
  "server": "0.0.0.0",
  "server_port": 8388,
  "local_address": "127.0.0.1",
  "local_port": 1080,
  "password": "'"$PASSWORD"'",
  "timeout": 300,
  "method": "aes-256-cfb",
  "fast_open": false
}'

# 创建 V2Ray 目录和配置文件
mkdir -p ~/v2ray
echo "$V2RAY_CONFIG" > ~/v2ray/config.json

# 创建 Shadowsocks 配置文件
echo "$SS_CONFIG" > ~/config.json

# 下载并解压 V2Ray
wget https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip -O ~/v2ray.zip
unzip ~/v2ray.zip -d ~/v2ray

# 运行 V2Ray
nohup ~/v2ray/v2ray -config ~/v2ray/config.json &

# 安装 Shadowsocks
pip install --user git+https://github.com/shadowsocks/shadowsocks.git@master

# 运行 Shadowsocks
nohup ~/.local/bin/ssserver -c ~/config.json &

# 获取服务器IP
SERVER_IP=$(curl -s ifconfig.me)

# 打印节点信息
echo "V2Ray 节点信息:"
echo "{
  \"protocol\": \"socks\",
  \"address\": \"$SERVER_IP\",
  \"port\": 1080,
  \"method\": \"noauth\"
}"
echo ""
echo "Shadowsocks 节点信息:"
echo "{
  \"server\": \"$SERVER_IP\",
  \"server_port\": 8388,
  \"password\": \"$PASSWORD\",
  \"method\": \"aes-256-cfb\"
}"
