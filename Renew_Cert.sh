#!/bin/bash

CERT_DIR="/etc/ssl/certs"
KEY_DIR="/etc/ssl/private"
CONF_FILE="/etc/ssl/openssl.cnf"

# Domain names to renew
DOMAINS=("nginx")

for DOMAIN in "${DOMAINS[@]}"; do
  CERT_FILE="$CERT_DIR/$DOMAIN.crt"
  KEY_FILE="$KEY_DIR/$DOMAIN.key"
  CSR_FILE="$CERT_DIR/$DOMAIN.csr"

  echo "Backing up current certificate and key for $DOMAIN..."
  cp $CERT_FILE $CERT_FILE.bak
  cp $KEY_FILE $KEY_FILE.bak

  echo "Generating new private key for $DOMAIN..."
  openssl genpkey -algorithm RSA -out $KEY_FILE

  echo "Generating new CSR for $DOMAIN..."
  openssl req -new -key $KEY_FILE -out $CSR_FILE -config $CONF_FILE -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=$DOMAIN"

  # Restart Nginx
  echo "Restarting web server for $DOMAIN..."
  systemctl restart nginx

  echo "Waiting for Nginx to restart and apply the new certificate..."
  sleep 10  

  if systemctl is-active --quiet nginx; then
    echo "Nginx restarted successfully for $DOMAIN."
  else
    echo "Error: Nginx failed to restart for $DOMAIN."
  fi

  echo "Verifying the new certificate for $DOMAIN..."
  openssl x509 -noout -dates -in $CERT_FILE

  echo "Certificate renewal completed for $DOMAIN."

done
