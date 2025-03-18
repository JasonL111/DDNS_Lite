# DDNS_Lite

This is a **Cloudflare Dynamic DNS (DDNS) update script** implemented using **Bash + curl + jq**.  
It automatically retrieves the public IPv4 address of your machine and updates the corresponding **A record** on Cloudflare, ensuring your dynamic IP is always synchronized with your domain.

## 🌐 Language语言
[中文](https://github.com/JasonL111/DDNS_Lite)

## 📌 Features

- Automatically retrieves the current public IPv4 address;
- Compares it with the existing Cloudflare DNS record;
- If the IP has changed, it updates the A record automatically;
- Supports logging, with **new logs added to the top**  for easy tracking.

## 🔧 Usage Instructions

1. Install Dependencies
```bash
sudo apt install curl jq
```

2. Configure the Script

Edit the `DDNS.sh` file and fill in your Cloudflare DNS API information:
```bash
ZONE_NAME="yourdomain.com"         # Root domain
RECORD_NAME="sub.yourdomain.com"   # Full subdomain (DNS record)
CF_API_TOKEN="your_cloudflare_api_token"  # Cloudflare API Token
```

3. Make the Script Executable
```bash
chmod +x DDNS.sh
```

4. Run the Script
```bash
./DDNS.sh
```

## ⏰ Automate with crontab

1. Open the Crontab Configuration
```bash
crontab -e
```

2. Add a Scheduled Task  
(Replace the path with your actual directory)
```bash
15 * * * * $HOME/bin/DDNS/DDNS.sh
```

This example runs the script every hour at 15 minutes past the hour.

---

