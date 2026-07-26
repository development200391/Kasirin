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
- [x] Halaman/tampilan struk (sesuai `TRANSA~2.svg`) — cetak bluetooth (Fase 10) & struk digital sudah bisa ditampilkan

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

## Fase 10 — Cetak Struk Printer Bluetooth

- [x] Tambah package printer thermal bluetooth (`print_bluetooth_thermal`, ESC/POS via `PostCode` bawaan package) + izin Bluetooth Android (`BLUETOOTH_CONNECT`, `BLUETOOTH_SCAN`, dll di `AndroidManifest.xml`) + `permission_handler` untuk runtime request Android 12+
- [x] Halaman Printer Bluetooth (UI) — status terhubung/tidak + daftar perangkat yang sudah dipasangkan (printer thermal Bluetooth Classic harus di-pair dulu lewat pengaturan Bluetooth HP; baterai tidak ditampilkan karena tidak didukung package untuk kebanyakan printer)
- [x] Tampilkan & refresh daftar perangkat bluetooth yang sudah dipasangkan
- [x] Connect / putuskan sambungan ke printer (+ auto-reconnect ke printer terakhir saat app dibuka)
- [x] Pilihan ukuran kertas 58mm / 80mm + simpan preferensi (`shared_preferences`)
- [x] Tombol "Test Print"
- [x] Toggle "Cetak Otomatis Setelah Transaksi" + hubungkan ke flow selesai transaksi (Fase 3, `payment_sheet.dart`)
- [x] Generate format struk ESC/POS sesuai ukuran kertas (`core/utils/receipt_formatter.dart`) — tombol "Cetak Struk" di halaman struk (Fase 3) kini fungsional


---

## Fase 11 — Laporan per Periode + Export

- [x] Query agregat transaksi per rentang tanggal (mingguan Senin-Minggu / bulanan kalender) — `report_repository.dart#getPeriodReport`
- [x] Halaman Laporan Periode (UI) — kartu ringkasan gradient + tabel rincian per hari (diadaptasi jadi layar mobile satu kolom, bukan sidebar seperti mockup awal); ada juga sebagai menu tersendiri di Dashboard ("Laporan Periode")
- [x] Toggle periode Mingguan/Bulanan (`SegmentedButton`) + navigasi periode sebelumnya/berikutnya (tombol berikutnya nonaktif kalau sudah di periode berjalan)
- [x] Hitung % perubahan penjualan vs periode sebelumnya
- [x] Hitung & tampilkan "hari terbaik" (penjualan tertinggi) dalam periode
- [x] Tabel rincian penjualan per hari (tanggal, jumlah transaksi, total)
- [x] Export laporan ke Excel (`excel` package, lalu dibagikan via share sheet)
- [x] Export laporan ke PDF (`pdf` package, tabel rincian per hari, lalu dibagikan via share sheet)


---

## Fase 12 — Backup / Restore Database

- [x] Fungsi backup: copy file database SQLite ke folder backup (`ApplicationDocumentsDirectory/backups`) + simpan metadata (waktu, ukuran, sumber Manual/Diimpor) di `history.json` terpisah dari `kasirin.db` (biar histori tidak ikut ketimpa saat restore)
- [x] Halaman Backup & Restore (UI) — diadaptasi jadi layar mobile satu kolom (bukan panel kiri-kanan seperti mockup awal): tombol backup di atas, riwayat + restore di bawah
- [x] Tombol "Backup Sekarang" (manual)
- [x] ~~Backup otomatis terjadwal~~ — dihilangkan sesuai keputusan: Flutter tidak bisa jalan saat app tertutup tanpa kode native Android (WorkManager/AlarmManager) yang tidak bisa diuji tanpa run di device, jadi backup dibuat manual saja (klik tombol)
- [x] List riwayat backup (tanggal, ukuran, badge Manual/Diimpor)
- [x] Fitur restore dari salah satu backup di riwayat + konfirmasi (menimpa data saat ini) — setelah restore, user otomatis logout & diarahkan ke Login supaya state aplikasi tidak nyangkut data lama
- [x] Import file backup dari luar (`file_picker`) — tombol "Import File Backup", divalidasi header SQLite dulu sebelum diterima
- [x] Pilihan lokasi penyimpanan: Lokal (default, aktif) + tombol "Bagikan" per backup (`share_plus`) untuk kirim/upload manual ke Google Drive atau layanan lain — tidak pakai Google Drive API langsung (di luar cakupan MVP offline app ini)

Menu "Backup & Restore" ada di Dashboard, dijaga permission `data.backup` (khusus role yang diberi akses, default: Admin).

---

## Fase 13 — Multi-Bahasa (Indonesia, Inggris, Jepang)

- [ ] Setup `flutter_localizations` + `intl` gen-l10n (`l10n.yaml`, folder `lib/l10n/`, file ARB per bahasa: `app_id.arb`, `app_en.arb`, `app_ja.arb`)
- [ ] Daftarkan `supportedLocales` (id, en, ja) + `localizationsDelegates` di `MaterialApp`
- [ ] Ekstrak semua teks UI yang masih hardcoded Bahasa Indonesia ke key ARB, lalu pakai `AppLocalizations.of(context)!.xxx` di semua layar (Login, Dashboard, POS, Produk, Stok, Laporan, Laporan Periode, Pengguna, Printer Bluetooth, Backup & Restore, Pengaturan)
- [ ] Terjemahkan ke Inggris dan Jepang (butuh review penutur asli terutama untuk Jepang — istilah kasir/struk/stok belum tentu pas kalau diterjemahkan mesin)
- [ ] Pilihan bahasa di halaman Pengaturan (Bahasa Indonesia / English / 日本語) + simpan preferensi (`shared_preferences`, sudah ada dependency-nya)
- [ ] Terapkan locale pilihan user ke `MaterialApp` (bukan cuma default sistem) + tetap dipakai lagi setelah app dibuka ulang
- [ ] Sesuaikan format angka/mata uang/tanggal ikut locale aktif (`formatCurrency`, `DateFormat` di seluruh app saat ini hardcode `id_ID`)
- [ ] Cek ulang layout tiap layar tidak pecah saat teks lebih panjang/pendek dari Bahasa Indonesia (mis. label tombol, judul AppBar, badge status)
