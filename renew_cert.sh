#!/bin/bash
CERT_DIR="/etc/nginx/ssl"
DOMAIN="localhost"
DAYS=365
mkdir -p "$CERT_DIR"
# renew certificate using existing key or create new certificate if none exists
renew_certificate() {
    # if key exists
    if [ -f "$CERT_DIR/$DOMAIN.key" ]; then
        echo "generate new certificate using existing private key"
        # Backup existing certificate
        if [ -f "$CERT_DIR/$DOMAIN.crt" ]; then
            mv "$CERT_DIR/$DOMAIN.crt" "$CERT_DIR/$DOMAIN.crt.backup"
        fi
        # Generate new certificate using existing key
        openssl req -x509 \
            -days $DAYS \
            -key "$CERT_DIR/$DOMAIN.key" \
            -out "$CERT_DIR/$DOMAIN.crt" \
            -subj "/C=US/ST=State/L=City/O=Organization/CN=$DOMAIN"
    else
        echo "No existing key found. Generate new key and certificate"
        # Generate new private key and new certificate
        openssl req -x509 -nodes \
            -days $DAYS \
            -newkey rsa:2048 \
            -keyout "$CERT_DIR/$DOMAIN.key" \
            -out "$CERT_DIR/$DOMAIN.crt" \
            -subj "/C=US/ST=State/L=City/O=Organization/CN=$DOMAIN"
    fi
    chmod 600 "$CERT_DIR/$DOMAIN.key"
    chmod 644 "$CERT_DIR/$DOMAIN.crt"
    # Reload Nginx
        systemctl reload nginx
    echo "Certificate has been renewed successfully!"
    }
check_expiry() {
    local cert="$CERT_DIR/$DOMAIN.crt"
  if [ -f "$cert_file" ]; then
        local expiration_date=$(openssl x509 -enddate -noout -in "$cert_file" | cut -d= -f2)
        local expiration_timestamp=$(date -d "$expiration_date" +%s)
        local current_timestamp=$(date +%s)
        local days_left=$(( ($expiration_timestamp - $current_timestamp) / 86400 ))
        echo "$days_left"
    else
        echo "0"
    fi
}
# Main script
days_left=$(check_expiry)
if [ "$days_left" -lt 30 ]; then
    renew_certificate
else
    echo "Certificate is valid for $days_left days. No renewal needed."
fi
