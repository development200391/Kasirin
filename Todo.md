# Todo — Kasirin (POS App)

Urutan pengerjaan per layar/fitur, dicek satu per satu. Referensi detail: [detail-pembuatan-pos-app.md](./detail-pembuatan-pos-app.md)

---

## Fase 0 — Setup Project

- [x] `flutter create` project + susun folder sesuai struktur (`core/`, `data/`, `features/`, `widgets/`)
- [x] Install dependency inti: `sqflite`, state management (Provider), `path_provider`, `intl`
- [x] Setup tema (warna/font sesuai mockup) + routing dasar

## Fase 1 — Login & Database

- [x] Buat schema database (`database_helper.dart`) — tabel `users`, `categories`, `products`, `stock_movements`, `transactions`, `transaction_items`
- [x] Seed 1 user admin default (biar bisa login pertama kali) — username `admin` / password `admin123`
- [x] Halaman Login (UI) — sesuai `Login-Screen.svg`: logo, field username/password, tombol masuk
- [x] Wire logika login (cek ke tabel `users`, hash password) + redirect ke Dashboard
- [x] Halaman Dashboard/Home (UI) — sesuai `MOBILE~1.SVG`: header gradient + ringkasan penjualan hari ini, menu utama (Mulai Transaksi, Kelola Produk, Transaksi & Struk, Laporan Penjualan, Pengguna, Pengaturan)

## Fase 2 — Produk & Kategori

- [x] Halaman Manajemen Produk (UI) — list, tombol tambah/edit/hapus, filter kategori
- [x] CRUD kategori
- [x] CRUD produk (termasuk upload foto)

## Fase 3 — Modul Kasir (inti aplikasi)

- [x] Halaman Transaksi Kasir (UI, dibuka dari menu "Mulai Transaksi") — search produk, kartu produk, ringkasan belanja
- [x] Logika keranjang: tambah item, hitung subtotal/total, diskon
- [x] Proses bayar (input uang bayar → hitung kembalian) + simpan ke `transactions` & `transaction_items`
- [x] Kurangi stok otomatis saat transaksi berhasil (+ catat `stock_movements`)
- [x] Halaman/tampilan struk (sesuai `TRANSA~2.svg`) — cetak bluetooth masih placeholder (Fase 10), struk digital sudah bisa ditampilkan

## Fase 4 — Stok

- [x] Halaman restock manual (Tambah Stok / Kurangi Stok) + catat ke `stock_movements` — akses dari ikon "Manajemen Stok" di AppBar halaman Produk
- [x] Riwayat pergerakan stok per produk

## Fase 5 — Laporan

- [x] Halaman Laporan Harian (total penjualan + % vs kemarin, grafik penjualan per jam, jumlah transaksi, list transaksi terbaru)

## Fase 9 — Multi-user & Role

- [x] Tambah kolom `is_active` dan `permissions` di tabel `users` (migrasi `_dbVersion` 1 → 2)
- [x] Halaman Manajemen Pengguna (UI) — list user (avatar inisial, nama, username, badge role), tap untuk buka Detail Pengguna (layar mobile penuh, bukan panel kanan)
- [x] Tombol "+ Tambah Pengguna" — form buat user baru (nama, username, password, role, hak akses)
- [x] Ubah role user — toggle Admin/Kasir (`SegmentedButton`)
- [x] Checklist hak akses per user (Transaksi Penjualan, Lihat Produk, Kelola Produk, Kelola Pengguna, Lihat Laporan Harian) + tombol "Simpan Perubahan"
- [x] Nonaktifkan/aktifkan pengguna (soft-disable via `is_active`, bukan hapus akun; login diblok jika nonaktif; tidak bisa menonaktifkan akun sendiri)
- [x] Guard akses menu Dashboard sesuai permission user yang sedang login (menu terkunci menampilkan ikon gembok + notifikasi jika ditekan)


---

## Lanjutan (setelah MVP jalan) — belum dikerjakan

### Fase 10 — Cetak Struk Printer Bluetooth
_Mockup: [bt_A_scan_list.svg](./assets/bt_A_scan_list.svg) — "Printer Bluetooth"_

- [ ] Tambah package printer thermal bluetooth (mis. `esc_pos_bluetooth` / `blue_thermal_printer`) + izin Bluetooth Android
- [ ] Halaman Printer Bluetooth (UI) — status printer aktif, baterai, daftar perangkat lain
- [ ] Scan & tampilkan daftar perangkat bluetooth tersedia
- [ ] Connect / putuskan sambungan ke printer
- [ ] Pilihan ukuran kertas 58mm / 80mm + simpan preferensi
- [ ] Tombol "Test Print"
- [ ] Toggle "Cetak Otomatis Setelah Transaksi" + hubungkan ke flow selesai transaksi (Fase 3)
- [ ] Generate format struk ESC/POS sesuai ukuran kertas

### Fase 11 — Laporan per Periode + Export
_Mockup: [periode_C_sidebar.svg](./assets/periode_C_sidebar.svg) — "Rincian per Hari"_

- [ ] Query agregat transaksi per rentang tanggal (mingguan/bulanan)
- [ ] Halaman Laporan Periode (UI) — sidebar ringkasan + tabel rincian per hari
- [ ] Toggle periode Mingguan/Bulanan + navigasi periode sebelumnya/berikutnya
- [ ] Hitung % perubahan penjualan vs periode sebelumnya
- [ ] Hitung & tampilkan "hari terbaik" (penjualan tertinggi) dalam periode
- [ ] Tabel rincian penjualan per hari (tanggal, jumlah transaksi, total)
- [ ] Export laporan ke Excel
- [ ] Export laporan ke PDF

### Fase 12 — Backup / Restore Database
_Mockup: [backup_A_two_panel.svg](./assets/backup_A_two_panel.svg) — "Backup & Restore Database"_

- [ ] Fungsi backup: copy file database SQLite ke folder backup + simpan metadata (waktu, ukuran, tipe manual/otomatis)
- [ ] Halaman Backup & Restore (UI) — panel kiri backup, panel kanan riwayat & restore
- [ ] Tombol "Backup Sekarang" (manual)
- [ ] Backup otomatis terjadwal (mis. tiap hari jam 23:00)
- [ ] List riwayat backup (tanggal, ukuran, badge Otomatis/Manual)
- [ ] Fitur restore dari salah satu backup di riwayat + konfirmasi (menimpa data saat ini)
- [ ] Import file backup dari luar (file picker) — "+ Import File Backup"
- [ ] Pilihan lokasi penyimpanan: Lokal / Google Drive (opsional, cloud)
