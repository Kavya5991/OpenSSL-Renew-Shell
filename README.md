# OpenSSL Renewal BASH Script

A simple bash script to automate SSL certificate renewal using OpenSSL for Nginx servers.

## Overview

This script automates:
- Certificate and key backup
- RSA private key generation
- CSR (Certificate Signing Request) generation
- Nginx restart
- Certificate validation

## Prerequisites

- Linux/Unix environment
- OpenSSL
- Nginx

## Quick Start

1. Save the script:
```bash
sudo vi /usr/local/bin/renew_cert.sh
```

2. Make executable:
```bash
sudo chmod +x /usr/local/bin/renew_cert.sh
```

3. Run:
```bash
sudo ./renew_cert.sh
