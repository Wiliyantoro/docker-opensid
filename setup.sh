#!/bin/bash

echo "========================================"
echo "   OpenSID Docker Production Setup"
echo "========================================"
echo ""

# ===============================
# 1. Input Repository OpenSID
# ===============================
read -p "Masukkan URL repository OpenSID (default: https://github.com/OpenSID/OpenSID.git): " REPO_URL

if [ -z "$REPO_URL" ]; then
  REPO_URL="https://github.com/OpenSID/OpenSID.git"
fi

echo ""
echo "Cloning repository: $REPO_URL"
git clone "$REPO_URL" opensid

if [ $? -ne 0 ]; then
  echo "Gagal clone repository. Periksa URL."
  exit 1
fi

# ===============================
# 2. Set Permission
# ===============================
echo ""
echo "Mengatur permission file..."
sudo chown -R 33:33 opensid
sudo chmod -R 755 opensid

# ===============================
# 3. Setup SSL
# ===============================
echo ""
read -p "Apakah ingin membuat SSL self-signed sekarang? (y/n): " SSL_CONFIRM

if [ "$SSL_CONFIRM" == "y" ]; then
  mkdir -p certs

  read -p "Masukkan domain (contoh: sid.domainanda.com): " DOMAIN_NAME

  openssl req -x509 -nodes -days 3650 \
  -newkey rsa:2048 \
  -keyout certs/opensid.key \
  -out certs/opensid.crt \
  -subj "/C=ID/ST=Indonesia/L=Desa/O=OpenSID/OU=IT/CN=$DOMAIN_NAME"

  echo "SSL self-signed berhasil dibuat."
else
  echo "Lewati pembuatan SSL. Pastikan file certs sudah ada."
fi

# ===============================
# 4. Jalankan Docker
# ===============================
echo ""
echo "Menjalankan Docker..."
docker compose up -d --build

echo ""
echo "========================================"
echo "Setup selesai!"
echo "Akses aplikasi di: https://DOMAIN_ANDA"
echo "========================================"
