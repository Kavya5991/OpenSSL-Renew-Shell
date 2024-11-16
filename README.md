# SSL Certificate Auto-Renewal Script

A Bash script to automatically check and renew SSL certificates for Nginx. The script checks the expiration date of existing certificates and renews them when they're within 30 days of expiring.

## Features

- Automatic certificate renewal when approaching expiration
- Preserves existing private keys when renewing
- Creates new key pairs if none exist
- Backs up existing certificates before renewal

## Usage

1. Clone this repository or download the script
2. Make the script executable:
```bash
chmod +x Renew_Cert.sh
```
3. Run the script manually:
```bash
sudo ./Renew-Cert.sh
```

4. For automatic renewal, add to crontab:
```bash
# Run daily at 3am
0 3 * * * /path/to/Renew-Cert.sh
```
## Configuration

Edit these variables at the top of the script to match your setup:
```bash
CERT_DIR="/etc/nginx/ssl"   # Certificate directory
DOMAIN="localhost"          # Domain name
DAYS=365                    # Validity period in days
