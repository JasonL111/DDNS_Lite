# DDNS_Lite

这是一个基于 **Bash + curl + jq** 实现的 **Cloudflare 动态 DNS（DDNS）更新脚本**，可自动获取本机公网 IP，并更新到 Cloudflare 上的 A 记录，实现动态公网 IP 的自动同步。

## 语言 Language
[英语](https://github.com/JasonL111/DDNS_Lite/blob/main/README.en-US.md)

## 📌 功能说明

- 自动获取本机公网 IPv4 地址；
- 比较是否与 Cloudflare DNS 中记录一致；
- 如有变化，则自动更新记录；
- 支持日志记录功能，新日志添加在头部，倒叙添加，方便追踪操作历史。


## 🔧使用方法
1. 安装依赖
```bash
sudo apt install curl jq
```
2. 编辑 DDNS.sh 文件，填入你的 Cloudflare DNS API信息：
```
ZONE_NAME="yourdomain.com"         # 一级域名
RECORD_NAME="sub.yourdomain.com"  # 二级域名（完整DNS记录）
CF_API_TOKEN="your_cloudflare_api_token"  # API 令牌
```
3. 赋予执行权限
```
chmod +x DDNS.sh
```
4. 运行
```
./DDNS.sh
```

## ⏰crontab自动运行
1. 打开任务列表
```
crontab -e
```
2. 添加任务（需要替换为真实目录）
```
15 * * * * $HOME/bin/DDNS/DDNS.sh
```
这是个每15分钟跑一次的例子