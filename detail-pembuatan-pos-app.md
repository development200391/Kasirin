# Detail Pembuatan Aplikasi POS (Point of Sale) - Kasirin

<img src="./assets/logo.svg" alt="Halaman Login Kasirin" width="80" />

Target: Aplikasi POS Android Kasirin, database lokal, rilis ke Google Play Store.

**Asumsi stack:** Flutter + SQLite (package `sqflite` atau `drift`). Kalau nanti mau ganti ke Kotlin native, struktur database & fitur di bawah tetap berlaku, hanya implementasi kode yang beda.

---

## 1. Cakupan Fitur

### MVP (wajib ada di rilis pertama)
- Login kasir/admin
- Manajemen produk & kategori (tambah, edit, hapus, upload foto)
- Modul kasir: pilih produk, hitung total, diskon, bayar, cetak/tampilkan struk
- Manajemen stok (otomatis berkurang saat transaksi, bisa restock manual)
- Riwayat transaksi & laporan penjualan harian

#### Mockup UI Kasirin (rancangan awal)
Berikut gambaran antarmuka MVP yang disarankan untuk aplikasi Kasirin:

- Halaman Login
  - Logo Kasirin di bagian atas
  - Field username dan password
  - Tombol Masuk
  - Opsi ingat saya / lupa password (opsional)

  Contoh visual mockup:
  - HTML tag (dengan ukuran tetap):

    <img src="./assets/Login-Screen.svg" alt="Halaman Login Kasirin" width="480" />

- Halaman Dashboard Kasir
  - Bagian pencarian produk
  - Kartu produk dengan nama, harga, stok
  - Ringkasan belanja di sisi kanan
  - Tombol diskon, bayar, batalkan transaksi

    <img src="./assets/DASHBO~1.svg" alt="Halaman Dashboard Kasir" width="1080" />



- Halaman Manajemen Produk
  - Daftar produk dengan foto, nama, harga, stok
  - Tombol tambah, edit, hapus produk
  - Filter berdasarkan kategori

    <img src="./assets/PRODUK~3.svg" alt="Halaman Manajemen Produk" width="1080" />

- Halaman Transaksi & Struk
  - Daftar item yang dibeli
  - Total belanja, diskon, uang bayar, kembalian
  - Tombol cetak / tampilkan struk

    <img src="./assets/TRANSA~2.svg" alt="Halaman Manajemen Produk" width="1080" />



- Halaman Laporan Harian
  - Total penjualan hari ini
  - Jumlah transaksi
  - Daftar transaksi terbaru

    <img src="./assets/laporan_B_chart.png" alt="Halaman Manajemen Produk" width="1080" />


### Lanjutan (setelah MVP jalan)
- Multi-user dengan role (admin, kasir)
    <img src="./assets/US7910~1.SVG" alt="Mockup Fitur Lanjutan Kasirin" width="1080" />
- Cetak struk via printer bluetooth
    <img src="./assets/bt_A_scan_list.svg" alt="Mockup Fitur Lanjutan Kasirin" width="1080" />

- Laporan per periode (mingguan, bulanan) + export
    <img src="./assets/periode_C_sidebar.svg" alt="Mockup Fitur Lanjutan Kasirin" width="1080" />

- Backup/restore database lokal
    <img src="./assets/backup_A_two_panel.svg" alt="Mockup Fitur Lanjutan Kasirin" width="1080" />

---

## 2. Skema Database

Skema berikut sudah disesuaikan dengan mockup MVP saat ini: login/admin, manajemen produk/kategori, stok, kasir/transaksi, dan laporan.

```mermaid
erDiagram
    USERS ||--o{ TRANSACTIONS : creates
    CATEGORIES ||--o{ PRODUCTS : contains
    PRODUCTS ||--o{ TRANSACTION_ITEMS : "sold in"
    PRODUCTS ||--o{ STOCK_MOVEMENTS : has
    TRANSACTIONS ||--o{ TRANSACTION_ITEMS : contains

    USERS {
        int id PK
        string name
        string username
        string password_hash
        string role
        datetime created_at
    }
    CATEGORIES {
        int id PK
        string name
    }
    PRODUCTS {
        int id PK
        int category_id FK
        string sku
        string name
        int price
        int cost_price
        int stock_qty
        string unit
        string image_path
        datetime created_at
    }
    STOCK_MOVEMENTS {
        int id PK
        int product_id FK
        string type
        int qty
        string note
        datetime created_at
    }
    TRANSACTIONS {
        int id PK
        int user_id FK
        string invoice_no
        int total_amount
        int discount
        int tax
        int paid_amount
        int change_amount
        string payment_method
        string status
        datetime created_at
    }
    TRANSACTION_ITEMS {
        int id PK
        int transaction_id FK
        int product_id FK
        int qty
        int price
        int subtotal
    }
```

Catatan:
- `stock_movements.type` bisa berisi nilai seperti `in`, `out`, `adjustment`.
- `transactions.status` untuk menandai transaksi `paid`, `void`, atau `refund`.

---

## 3. Struktur Project (Flutter)

```
lib/
  main.dart
  core/
    constants.dart
    theme.dart
    utils/
  data/
    db/
      database_helper.dart
      migrations/
    models/
      product.dart
      transaction.dart
      user.dart
    repositories/
      product_repository.dart
      transaction_repository.dart
      stock_repository.dart
  features/
    auth/
    products/
    pos/            # layar kasir (inti aplikasi)
    stock/
    reports/
    settings/
  widgets/           # komponen UI yang dipakai bersama
```

---

## 4. Tahapan Pengembangan

| Fase | Aktivitas | Estimasi |
|---|---|---|
| 0 | Setup project, pilih stack final, wireframe UI, buat akun Play Console | 3-5 hari |
| 1 | Setup database lokal + auth login | 1 minggu |
| 2 | Manajemen produk & kategori | 1 minggu |
| 3 | Modul kasir/transaksi (fitur inti) | 1.5-2 minggu |
| 4 | Manajemen stok | 3-5 hari |
| 5 | Laporan penjualan | 3-5 hari |
| 6 | Polish UI, cetak struk (opsional printer bluetooth) | 1 minggu |
| 7 | Testing internal & perbaikan bug | 1 minggu |
| 8 | Closed testing & publish ke Play Store | 2-3 minggu (termasuk masa tunggu Google) |

---

## 5. Syarat Publish ke Google Play Store

- [ ] Akun Google Play Console (bayar sekali, sekitar $25)
- [ ] Privacy Policy (URL publik) — tetap wajib meski app offline, karena app minta izin storage/kamera
- [ ] Data Safety Form — deklarasi data apa saja yang diakses/disimpan app
- [ ] App icon 512x512 px
- [ ] Feature graphic 1024x500 px
- [ ] Screenshot minimal 2 (disarankan 4-8)
- [ ] Deskripsi singkat & lengkap aplikasi
- [ ] App signing (Play App Signing, direkomendasikan Google)
- [ ] Target API level sesuai kebijakan terbaru Google Play
- [ ] Closed testing: minimal 12 tester aktif selama 14 hari berturut-turut (wajib untuk akun developer baru sebelum bisa rilis ke production)
- [ ] Kategori aplikasi: Business / Productivity

---

## 6. Hal yang Perlu Diputuskan Sebelum Mulai Coding

1. Final tech stack (Flutter vs Kotlin native)
2. Apakah butuh multi-user/role dari awal atau cukup single user dulu
3. Apakah butuh cetak struk fisik (printer bluetooth) di MVP atau nanti
4. Model bisnis: dijual ke banyak toko (butuh lisensi/aktivasi) atau untuk 1 toko sendiri
