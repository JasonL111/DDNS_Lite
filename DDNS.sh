#!/bin/bash

LOG_FILE="$HOME/bin/DDNS/DDNS.log"  # 自定义日志文件路径
touch "$LOG_FILE"

# Cloudflare API 配置
ZONE_NAME=" "          # 一级域名
RECORD_NAME=" "# 二级域名
CF_API_TOKEN=" "  # Cloudflare API 令牌

# 获取 Zone ID
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=${ZONE_NAME}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" | jq -r '.result[0].id')

# 获取记录 ID
RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${RECORD_NAME}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" | jq -r '.result[0].id')

# 获取当前记录指向的 IP（即 Cloudflare 中现有的 IP）
CF_IP=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records?name=${RECORD_NAME}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" | jq -r '.result[0].content')
# 获取当前公网 IP
CURRENT_IP=$(
    curl -s --connect-timeout 5 https://ipv4.icanhazip.com || \
    curl -s --connect-timeout 5 https://ifconfig.me/ip || \
    curl -s --connect-timeout 5 http://ipinfo.io/ip
)

# 如果 IP 没有变化则无需更新
if [ "$CURRENT_IP" = "$CF_IP" ]; then
    sed -i "1s|^|[$(date)] IP 未改变，无需更新: ${CURRENT_IP}\n|" "$LOG_FILE"   #Logging message, you can change it into English
    exit 0
fi

# 更新 DNS 记录
UPDATE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
    -H "Authorization: Bearer ${CF_API_TOKEN}" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"${RECORD_NAME}\",\"content\":\"${CURRENT_IP}\",\"ttl\":120,\"proxied\":false}")


# 检查结果并且记录到日志
if echo "$UPDATE" | grep -q '"success":true'; then
    sed -i "1s|^|[$(date)] DNS 记录更新成功: ${CURRENT_IP}\n|" "$LOG_FILE" # Logging message, you can change it into English
else
    sed -i "1s|^|[$(date)] DNS 记录更新失败!\n|" "$LOG_FILE" # Logging message
    sed -i "1s|^|$UPDATE\n|" "$LOG_FILE"
fi