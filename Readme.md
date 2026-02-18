# 🚀 OpenSID Docker Production Setup

Konfigurasi Docker siap produksi untuk menjalankan **OpenSID** menggunakan:

- 🐘 PHP 8.1 (Stabil untuk OpenSID)
- 🌐 Apache + SSL
- 🗄️ MariaDB 10.11
- 🐳 Docker Compose
- 🔐 Dukungan HTTPS
- 📦 phpMyAdmin
- ⚙️ Installer interaktif (`setup.sh`)

Repository ini hanya berisi konfigurasi Docker.  
Source code OpenSID tetap diambil dari repository resmi atau repository pilihan Anda.

---

# 📌 Fitur

- ✅ Tidak memodifikasi source OpenSID
- ✅ Aman untuk repository publik
- ✅ Konfigurasi berbasis `.env`
- ✅ Mendukung SSL (Self-Signed / Let's Encrypt / Cloudflare)
- ✅ Installer otomatis interaktif
- ✅ Setup sekali jalan
- ✅ Production-ready configuration
- ✅ Mudah dipindahkan ke server lain

---

# 🏗️ Arsitektur

```
Client (HTTPS)
        ↓
Apache + PHP 8.1
        ↓
OpenSID
        ↓
MariaDB 10.11
```

---

# 📋 Kebutuhan Sistem

- Ubuntu Server 22.04 / 24.04
- Docker & Docker Compose
- Domain mengarah ke IP server
- Port 80 dan 443 terbuka
- RAM minimal 2GB (disarankan 4GB)

---

# ⚡ Instalasi Cepat (Otomatis - Direkomendasikan)

## 1️⃣ Clone Repository

```bash
git clone https://github.com/USERNAME/opensid-docker.git
cd opensid-docker
```

## 2️⃣ Jalankan Installer

```bash
chmod +x setup.sh
./setup.sh
```

Installer akan:

1. Meminta URL repository OpenSID
2. Clone source ke folder `opensid/`
3. Mengatur permission file otomatis
4. Menawarkan pembuatan SSL self-signed
5. Menjalankan `docker compose up -d --build`

Setelah selesai:

```
https://domainanda.com
```

---

# 🛠 Instalasi Manual (Opsional)

## 1️⃣ Clone Repository Ini

```bash
git clone https://github.com/USERNAME/opensid-docker.git
cd opensid-docker
```

## 2️⃣ Clone OpenSID

```bash
git clone https://github.com/OpenSID/OpenSID.git opensid
```

## 3️⃣ Konfigurasi Environment

```bash
cp .env.example .env
```

Edit `.env`:

```env
DOMAIN=sid.domainanda.com
DB_ROOT_PASSWORD=passwordkuat
DB_NAME=opensid
DB_USER=opensid
DB_PASSWORD=passwordkuat
```

## 4️⃣ Tambahkan SSL (Jika Tidak Pakai Installer)

Letakkan file di:

```
certs/
├── opensid.crt
└── opensid.key
```

## 5️⃣ Jalankan Docker

```bash
docker compose up -d --build
```

---

# 🌍 Akses Aplikasi

- 🔗 OpenSID → https://domainanda.com
- 🗄️ phpMyAdmin → http://domainanda.com:8081

---

# 🛠 Perintah Manajemen

### Stop

```bash
docker compose down
```

### Restart

```bash
docker compose restart
```

### Lihat Log

```bash
docker logs opensid-web
```

### Update & Rebuild

```bash
git pull
docker compose up -d --build
```

---

# 🔐 Keamanan

Jangan commit file berikut:

- `.env`
- `certs/`
- `opensid/`
- `db_data/`

Gunakan password database yang kuat.  
Gunakan SSL resmi untuk produksi publik.

---

# 📦 Konfigurasi PHP

Pengaturan default:

- memory_limit = 512M
- upload_max_filesize = 128M
- max_execution_time = 300
- display_errors = Off

---

# 📊 Rekomendasi Produksi

Untuk penggunaan produksi:

- Aktifkan firewall (UFW)
- Gunakan Let's Encrypt otomatis
- Tambahkan backup database harian
- Gunakan Cloudflare Full Strict (opsional)
- Monitoring resource server

---

# ❤️ Tentang OpenSID

OpenSID adalah sistem informasi desa open-source untuk mendukung administrasi desa di Indonesia.

Repository resmi:
https://github.com/OpenSID/OpenSID

---

# 📄 Lisensi

Repository ini hanya menyediakan konfigurasi Docker.  
Lisensi OpenSID mengikuti repository resmi OpenSID.

---

# 🙌 Kontribusi

Pull Request dan saran sangat terbuka.

---

# ⭐ Dukungan

Jika repository ini membantu Anda, beri ⭐ di GitHub.
