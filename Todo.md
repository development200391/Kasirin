Urutan pengerjaan (per layar, biar bisa dicek satu-satu):

Fase 0 — Setup

flutter create project + susun folder sesuai struktur di dokumen (core/, data/, features/, widgets/)
Install dependency inti: sqflite, state management (Provider/Riverpod), path_provider, intl
Setup tema (warna/font sesuai mockup) + routing dasar
Fase 1 — Login & Database
4. Buat schema database (database_helper.dart) — tabel users, categories, products, stock_movements, transactions, transaction_items
5. Seed 1 user admin default (biar bisa login pertama kali)
6. Halaman Login (UI) — sesuai Login-Screen.svg: logo, field username/password, tombol masuk
7. Wire logika login (cek ke tabel users, hash password) + redirect ke Dashboard

Fase 2 — Produk & Kategori
8. Halaman Manajemen Produk (UI) — list, tombol tambah/edit/hapus, filter kategori
9. CRUD kategori
10. CRUD produk (termasuk upload foto)

Fase 3 — Modul Kasir (inti aplikasi)
11. Halaman Dashboard Kasir (UI) — search produk, kartu produk, ringkasan belanja
12. Logika keranjang: tambah item, hitung subtotal/total, diskon
13. Proses bayar (input uang bayar → hitung kembalian) + simpan ke transactions & transaction_items
14. Kurangi stok otomatis saat transaksi berhasil
15. Halaman/tampilan struk (sesuai TRANSA~2.svg)

Fase 4 — Stok
16. Halaman restock manual + catat ke stock_movements
17. Riwayat pergerakan stok per produk

Fase 5 — Laporan
18. Halaman Laporan Harian (total penjualan, jumlah transaksi, list transaksi terbaru)

Fase 6 — Polish
19. Rapikan UI semua halaman, cek responsif
20. (Opsional) cetak struk via printer bluetooth

Fase 7-8 — Testing & Publish
21. Testing manual tiap flow (login → produk → transaksi → laporan)
22. Siapkan aset Play Store & publish