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

- [x] Setup `flutter_localizations` + `intl` gen-l10n (`l10n.yaml`, folder `lib/l10n/`, file ARB per bahasa: `app_id.arb`, `app_en.arb`, `app_ja.arb`) — `intl` diturunkan ke `^0.20.2` karena dipin oleh `flutter_localizations`
- [x] Daftarkan `supportedLocales` (id, en, ja) + `localizationsDelegates` di `MaterialApp` (`main.dart`, dibungkus `Consumer<LocaleProvider>` biar ganti bahasa langsung rebuild)
- [x] Ekstrak semua teks UI yang tadinya hardcode Bahasa Indonesia ke ~180 key ARB, dipakai lewat `AppLocalizations.of(context)` di seluruh layar (Login, Dashboard, POS, Keranjang, Pembayaran, Struk, Produk, Kategori, Stok, Laporan Harian, Laporan Periode, Pengguna, Printer Bluetooth, Backup & Restore, Pengaturan) — termasuk label hak akses (`core/permissions.dart`) dan pesan error login (`AuthProvider` sekarang simpan flag `hasError`, bukan string, biar UI yang render pesannya sesuai bahasa aktif)
- [x] Terjemahkan ke Inggris dan Jepang — draft awal oleh Claude, **belum direview penutur asli**, terutama istilah Jepang untuk kasir/struk/stok
- [x] Pilihan bahasa di halaman Pengaturan (Bahasa Indonesia / English / 日本語) + simpan preferensi (`shared_preferences`) — `LocaleProvider`
- [x] Terapkan locale pilihan user ke `MaterialApp` + tetap dipakai lagi setelah app dibuka ulang
- [x] Format tanggal (nama hari/bulan) ikut locale aktif — `Intl.defaultLocale` di-update tiap ganti bahasa, semua `DateFormat(...)` di app sudah tidak hardcode `id_ID` lagi. Format mata uang (`formatCurrency`) **sengaja tetap Rupiah/format Indonesia** di bahasa apa pun karena itu representasi uang sungguhan (Rupiah), bukan preferensi tampilan — ganti bahasa UI tidak boleh terlihat seperti konversi mata uang
- [ ] Cek ulang layout tiap layar tidak pecah saat teks lebih panjang/pendek dari Bahasa Indonesia (mis. label tombol, judul AppBar, badge status) — belum dicek visual di device/emulator

---

## Fase 14 — Publish ke Google Play Store

_Checklist syarat store sudah ada juga di [detail-pembuatan-pos-app.md §5](./detail-pembuatan-pos-app.md#5-syarat-publish-ke-google-play-store); bagian di bawah fokus ke langkah teknis + akun._

- [ ] Buat akun Google Play Console (bayar sekali, ~$25) — akun & pembayaran harus dilakukan user, bukan Claude
- [ ] Setup **release signing config** — saat ini `android/app/build.gradle.kts` masih pakai `signingConfigs.getByName("debug")` (lihat baris 32), belum siap rilis. Perlu: generate keystore `.jks`, simpan `key.properties` (di luar git), update `build.gradle.kts` buat pakai signing release. **Keystore ini wajib disimpan aman — hilang keystore = tidak bisa update app yang sama lagi.**
- [ ] Tentukan `applicationId` final (`com.kasirin.kasirin`) — tidak bisa diganti setelah publish pertama, pastikan sudah yakin
- [ ] Set `version:` di `pubspec.yaml` buat rilis pertama (format `x.y.z+build`)
- [ ] Privacy Policy (URL publik) — wajib meski app offline, karena app minta izin storage/kamera/Bluetooth
- [ ] Data Safety Form di Play Console — deklarasi data yang diakses/disimpan (foto produk, database transaksi lokal, koneksi Bluetooth printer)
- [ ] App icon 512×512 px, Feature graphic 1024×500 px, screenshot minimal 2 (disarankan 4-8)
- [ ] Deskripsi singkat & lengkap aplikasi buat listing
- [ ] Kategori aplikasi: Business / Productivity
- [ ] Build App Bundle rilis: `flutter build appbundle --release`
- [ ] Target API level sesuai kebijakan terbaru Google Play (cek `flutter.compileSdkVersion`/`targetSdkVersion` masih dalam batas yang diwajibkan Play saat submit)
- [ ] Closed testing: minimal 12 tester aktif selama 14 hari berturut-turut (wajib untuk akun developer baru sebelum rilis production)
- [ ] Submit ke production setelah closed testing selesai

## Fase 15 — Publish ke Apple App Store

- [ ] **Catatan penting**: project ini belum punya folder `ios/` (`flutter create` sebelumnya khusus Android) — perlu `flutter create . --platforms=ios` dulu buat nambahin platform iOS
- [ ] **Build & submit iOS wajib pakai macOS + Xcode** — tidak bisa dari Windows (environment kerja saat ini). Tahap ini butuh Mac fisik/virtual terpisah
- [ ] Daftar Apple Developer Program (~$99/tahun) — akun & pembayaran dilakukan user
- [ ] Setup Bundle Identifier, signing certificate & provisioning profile via Xcode / App Store Connect
- [ ] Uji semua fitur yang sensitif-platform di iOS (belum pernah dites di iOS sama sekali): printer Bluetooth (`print_bluetooth_thermal` support iOS terbatas, perlu dicek), image picker/cropper, file picker, share sheet, local notification-style permission prompts
- [ ] Sesuaikan `Info.plist`: usage description buat kamera, photo library, Bluetooth (`NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, `NSBluetoothAlwaysUsageDescription`, dll) sesuai fitur yang sudah ada
- [ ] App icon set iOS (semua resolusi) + launch screen
- [ ] Privacy Policy URL + isi "App Privacy" / Privacy Nutrition Label di App Store Connect
- [ ] Screenshot untuk berbagai ukuran layar iPhone/iPad yang disyaratkan
- [ ] Deskripsi, kategori, keywords listing di App Store Connect
- [ ] Archive & upload build rilis lewat Xcode Organizer / Transporter
- [ ] TestFlight testing (disarankan) sebelum submit
- [ ] Submit for App Review
