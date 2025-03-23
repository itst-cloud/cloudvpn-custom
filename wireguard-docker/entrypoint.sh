#!/bin/bash

# 1. Generate keys and config
cd /config
umask 077
wg genkey | tee privatekey | wg pubkey > publickey

cat <<EOF > wg0.conf
[Interface]
PrivateKey = $(<privatekey)
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = $(<publickey)
AllowedIPs = 0.0.0.0/0
EOF

# 2. Log connection attempts
touch /config/wg.log
chmod 600 /config/wg.log

# 3. Generate QR code
qrencode -t PNG -o /config/wg-client.png < wg0.conf

# 4. Upload to S3 (requires awscli + config)
aws s3 cp wg-client.png s3://your-s3-bucket/wg-client.png
aws s3 cp wg0.conf s3://your-s3-bucket/wg0.conf

exec docker-entrypoint.sh
