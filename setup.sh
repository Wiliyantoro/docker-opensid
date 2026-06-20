#!/bin/bash

echo "========================================"
echo " OpenSID Docker Production Setup"
echo "========================================"
echo ""

# ===============================
# 1. Input Repository OpenSID
# ===============================
read -p "Masukkan URL repository OpenSID (default: https://github.com/OpenSID/OpenSID.git): " REPO_URL

if [ -z "$REPO_URL" ]; then
 REPO_URL="https://github.com/OpenSID/OpenSID.git"
fi

# Handle existing opensid directory
if [ -d "opensid" ]; then
    echo ""
    echo "Directory 'opensid' sudah ada."
    read -p "Hapus dan clone ulang? (y/n): " REMOVE_CONFIRM
    if [ "$REMOVE_CONFIRM" == "y" ]; then
        rm -rf opensid
    else
        echo "Menggunakan directory 'opensid' yang sudah ada."
    fi
fi

if [ ! -d "opensid" ]; then
    echo ""
    echo "Cloning repository: $REPO_URL"
    git clone "$REPO_URL" opensid

    if [ $? -ne 0 ]; then
     echo "Gagal clone repository. Periksa URL."
     exit 1
    fi

    # ===============================
    # 2. Set Permission (jika sebagai root)
    # ===============================
    echo ""
    echo "Mengatur permission file..."
    if [ "$(id -u)" -eq 0 ]; then
        chown -R 33:33 opensid
        chmod -R 755 opensid
    else
        echo "Warning: Tidak berjalan sebagai root. Lewati chown/chmod."
        echo "Pastikan permission file sesuai untuk container Docker."
    fi
fi

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
# 4. Update DOMAIN di .env jika SSL dibuat
# ===============================
echo ""
if [ ! -f ".env" ]; then
    cp env.example .env
fi

if [ "$SSL_CONFIRM" == "y" ] && [ -n "$DOMAIN_NAME" ]; then
    sed -i "s/^DOMAIN=.*/DOMAIN=$DOMAIN_NAME/" .env || true
    echo "DOMAIN di-update ke: $DOMAIN_NAME"
fi

# ===============================
# 5. Jalankan Docker
# ===============================
echo ""
echo "Menjalankan Docker..."
docker compose up -d --build

echo ""
echo "========================================"
echo "Setup selesai!"
echo "Akses aplikasi di: https://${DOMAIN:-domainanda.com}"
echo "========================================"
