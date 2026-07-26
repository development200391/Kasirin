// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonSave => 'Simpan';

  @override
  String get commonAdd => 'Tambah';

  @override
  String get commonDelete => 'Hapus';

  @override
  String get commonYes => 'Ya';

  @override
  String get commonNo => 'Tidak';

  @override
  String get commonOk => 'OK';

  @override
  String get commonClose => 'Tutup';

  @override
  String get commonSubtotal => 'Subtotal';

  @override
  String get commonDiscount => 'Diskon';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonAll => 'Semua';

  @override
  String get commonAdmin => 'Admin';

  @override
  String get commonCashier => 'Kasir';

  @override
  String get commonActive => 'Aktif';

  @override
  String get commonInactive => 'Nonaktif';

  @override
  String get commonConnect => 'Hubungkan';

  @override
  String get commonDisconnect => 'Putuskan';

  @override
  String get commonRestore => 'Pulihkan';

  @override
  String get commonManual => 'Manual';

  @override
  String get commonImported => 'Diimpor';

  @override
  String get commonShare => 'Bagikan';

  @override
  String get commonPaidCash => 'Tunai';

  @override
  String get commonPaidQris => 'QRIS';

  @override
  String get commonPaidDebit => 'Kartu Debit';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginUsernameRequired => 'Username wajib diisi';

  @override
  String get loginPassword => 'Kata Sandi';

  @override
  String get loginPasswordRequired => 'Kata sandi wajib diisi';

  @override
  String get loginSubmit => 'Masuk';

  @override
  String get loginWelcome => 'Selamat Datang';

  @override
  String get loginSubtitle => 'Masuk untuk melanjutkan';

  @override
  String get authInvalidCredentials => 'Username atau kata sandi salah';

  @override
  String get dashboardMenuTitle => 'Menu Utama';

  @override
  String get dashboardGreeting => 'Selamat datang,';

  @override
  String get dashboardSalesToday => 'Penjualan Hari Ini';

  @override
  String get dashboardTransactions => 'Transaksi';

  @override
  String get dashboardMenuPos => 'Mulai Transaksi';

  @override
  String get dashboardMenuProducts => 'Kelola Produk';

  @override
  String get dashboardMenuReports => 'Laporan Penjualan';

  @override
  String get dashboardMenuPeriodReports => 'Laporan Periode';

  @override
  String get dashboardMenuUsers => 'Pengguna';

  @override
  String get dashboardMenuPrinter => 'Printer Bluetooth';

  @override
  String get dashboardMenuBackup => 'Backup & Restore';

  @override
  String get dashboardMenuSettings => 'Pengaturan';

  @override
  String get dashboardNotifications => 'Notifikasi';

  @override
  String dashboardFeatureUnavailable(String feature) {
    return '$feature belum tersedia';
  }

  @override
  String get dashboardAccessDenied => 'Anda tidak memiliki akses ke menu ini';

  @override
  String get posTitle => 'Transaksi Kasir';

  @override
  String get posSearchHint => 'Cari produk atau SKU...';

  @override
  String get posProductNotFound => 'Produk tidak ditemukan';

  @override
  String get posOutOfStock => 'Stok tidak mencukupi';

  @override
  String posStockBadge(int qty) {
    return 'Stok $qty';
  }

  @override
  String get posViewOrder => 'Lihat Pesanan';

  @override
  String get cartCurrentOrder => 'Pesanan Saat Ini';

  @override
  String cartItemCount(int count) {
    return '$count item';
  }

  @override
  String get cartEmpty => 'Keranjang masih kosong';

  @override
  String get cartDiscountLabel => 'Jumlah diskon';

  @override
  String get cartCancelTransaction => 'Batalkan Transaksi';

  @override
  String get cartConfirmClear => 'Kosongkan semua item di keranjang?';

  @override
  String get cartConfirmCancel => 'Ya, Batalkan';

  @override
  String get cartCancelButton => 'Batalkan';

  @override
  String cartPay(String amount) {
    return 'Bayar $amount';
  }

  @override
  String get paymentTitle => 'Pembayaran';

  @override
  String get paymentTotalBelanja => 'Total Belanja';

  @override
  String get paymentAmountPaid => 'Uang Bayar';

  @override
  String get paymentChange => 'Kembalian';

  @override
  String get paymentConfirm => 'Konfirmasi Bayar';

  @override
  String get receiptDigitalTitle => 'Struk Digital';

  @override
  String get receiptSuccess => 'Pembayaran Berhasil!';

  @override
  String get receiptChangeLabel => 'KEMBALIAN';

  @override
  String get receiptPrint => 'Cetak Struk';

  @override
  String get receiptPrinterNotConnected => 'Printer belum terhubung';

  @override
  String get receiptPrintSuccess => 'Struk berhasil dicetak';

  @override
  String get receiptPrintFailed => 'Gagal mencetak struk';

  @override
  String get receiptShowDigital => 'Tampilkan Struk Digital';

  @override
  String get receiptNewTransaction => 'Transaksi Baru';

  @override
  String get categoryNewTitle => 'Kategori Baru';

  @override
  String get categoryEditTitle => 'Ubah Kategori';

  @override
  String get categoryNameLabel => 'Nama kategori';

  @override
  String get categoryDeleteTitle => 'Hapus Kategori';

  @override
  String categoryDeleteConfirm(String name) {
    return 'Hapus \"$name\"? Produk yang memakai kategori ini akan menjadi tanpa kategori.';
  }

  @override
  String get categoriesTitle => 'Kelola Kategori';

  @override
  String get categoriesEmpty => 'Belum ada kategori';

  @override
  String get categoryAdd => 'Tambah Kategori';

  @override
  String get productFormEditTitle => 'Edit Produk';

  @override
  String get productFormAddTitle => 'Tambah Produk';

  @override
  String get productFormName => 'Nama Produk';

  @override
  String get productFormNameRequired => 'Nama wajib diisi';

  @override
  String get productFormSku => 'SKU (opsional)';

  @override
  String get productFormCategory => 'Kategori';

  @override
  String get productFormNoCategory => 'Tanpa kategori';

  @override
  String get productFormNewCategory => 'Kategori baru';

  @override
  String get productFormPrice => 'Harga Jual';

  @override
  String get productFormRequired => 'Wajib diisi';

  @override
  String get productFormMustBeNumber => 'Harus angka';

  @override
  String get productFormCostPrice => 'Harga Modal';

  @override
  String get productFormStock => 'Stok';

  @override
  String get productFormUnit => 'Satuan (mis. pcs)';

  @override
  String get productFormSaveChanges => 'Simpan Perubahan';

  @override
  String get productFormCropTitle => 'Sesuaikan Foto';

  @override
  String get productsTitle => 'Manajemen Produk';

  @override
  String get productsStockTooltip => 'Manajemen Stok';

  @override
  String get productsCategoryTooltip => 'Kelola Kategori';

  @override
  String get productsSearchHint => 'Cari nama produk atau SKU...';

  @override
  String get productsEmpty => 'Belum ada produk';

  @override
  String get productsDeleteTitle => 'Hapus Produk';

  @override
  String productsDeleteConfirm(String name) {
    return 'Hapus \"$name\"? Tindakan ini tidak bisa dibatalkan.';
  }

  @override
  String get productsAdd => 'Tambah Produk';

  @override
  String get stockTitle => 'Manajemen Stok';

  @override
  String get stockCurrentLabel => 'Stok Saat Ini';

  @override
  String get stockAdd => 'Tambah Stok';

  @override
  String get stockReduce => 'Kurangi Stok';

  @override
  String get stockHistoryTitle => 'Riwayat Pergerakan Stok';

  @override
  String get stockHistoryEmpty => 'Belum ada pergerakan stok';

  @override
  String get stockQtyLabel => 'Jumlah';

  @override
  String get stockNoteLabel => 'Catatan (opsional)';

  @override
  String get stockMovementIn => 'Masuk';

  @override
  String get stockMovementOut => 'Keluar (Transaksi)';

  @override
  String get stockMovementAdjustment => 'Penyesuaian';

  @override
  String get reportsTitle => 'Laporan Harian';

  @override
  String get reportsTotalSalesToday => 'Total Penjualan Hari Ini';

  @override
  String reportsChangeVsYesterday(String percent) {
    return '$percent% dari kemarin';
  }

  @override
  String get reportsSalesPerHour => 'Penjualan per Jam';

  @override
  String get reportsNoSalesToday => 'Belum ada penjualan hari ini';

  @override
  String get reportsTransactionCount => 'Jumlah Transaksi';

  @override
  String reportsTransactionDelta(String delta) {
    return '$delta transaksi';
  }

  @override
  String get reportsRecentTransactions => 'Transaksi Terbaru';

  @override
  String get reportsNoTransactions => 'Belum ada transaksi';

  @override
  String reportsTransactionSummary(String time, int count, String method) {
    return '$time · $count item · $method';
  }

  @override
  String get periodTitle => 'Laporan Periode';

  @override
  String get periodWeekly => 'Mingguan';

  @override
  String get periodMonthly => 'Bulanan';

  @override
  String get periodExportExcel => 'Export ke Excel';

  @override
  String get periodExportPdf => 'Export ke PDF';

  @override
  String get periodDailyBreakdown => 'Rincian per Hari';

  @override
  String get periodTotalSales => 'TOTAL PENJUALAN';

  @override
  String periodChangeVsPrevious(String percent) {
    return '$percent% dari periode lalu';
  }

  @override
  String get periodTransactionCount => 'JUMLAH TRANSAKSI';

  @override
  String get periodBestDay => 'HARI TERBAIK';

  @override
  String get periodColDate => 'HARI / TANGGAL';

  @override
  String get periodColTransactions => 'TRANSAKSI';

  @override
  String get periodColSales => 'PENJUALAN';

  @override
  String periodTrxSuffix(int count) {
    return '$count trx';
  }

  @override
  String get periodExportFailed => 'Gagal membuat file laporan';

  @override
  String get periodReportHeading => 'Laporan Periode Kasirin';

  @override
  String get usersTitle => 'Manajemen Pengguna';

  @override
  String get usersEmpty => 'Belum ada pengguna';

  @override
  String get usersAdd => 'Tambah Pengguna';

  @override
  String get usersInactiveSuffix => '· Nonaktif';

  @override
  String get userDetailTitle => 'Detail Pengguna';

  @override
  String get userDetailSaved => 'Perubahan disimpan';

  @override
  String get userDetailCantDisableSelf =>
      'Anda tidak bisa menonaktifkan akun sendiri';

  @override
  String get userDetailActivateTitle => 'Aktifkan Pengguna';

  @override
  String get userDetailDeactivateTitle => 'Nonaktifkan Pengguna';

  @override
  String userDetailActivateBody(String name) {
    return '$name akan bisa login kembali.';
  }

  @override
  String userDetailDeactivateBody(String name) {
    return '$name tidak akan bisa login sampai diaktifkan kembali.';
  }

  @override
  String get userDetailActivate => 'Aktifkan';

  @override
  String get userDetailDeactivate => 'Nonaktifkan';

  @override
  String get userDetailRole => 'Role Pengguna';

  @override
  String get userDetailPermissions => 'Hak Akses';

  @override
  String get userDetailSaveChanges => 'Simpan Perubahan';

  @override
  String get userFormTitle => 'Tambah Pengguna';

  @override
  String get userFormFullName => 'Nama Lengkap';

  @override
  String get userFormUsernameTaken => 'Username sudah dipakai';

  @override
  String get userFormPasswordMinLength => 'Minimal 6 karakter';

  @override
  String get permissionPosTransaction => 'Transaksi Penjualan';

  @override
  String get permissionProductsView => 'Lihat Produk';

  @override
  String get permissionProductsManage => 'Kelola Produk';

  @override
  String get permissionUsersManage => 'Kelola Pengguna';

  @override
  String get permissionReportsView => 'Lihat Laporan Harian';

  @override
  String get permissionDataBackup => 'Backup & Restore Data';

  @override
  String get printerTitle => 'Printer Bluetooth';

  @override
  String get printerPairedDevices => 'Perangkat Berpasangan';

  @override
  String get printerNoPairedDevices =>
      'Belum ada printer yang dipasangkan. Pasangkan printer melalui pengaturan Bluetooth HP terlebih dahulu, lalu tekan refresh.';

  @override
  String get printerPaperSize => 'Ukuran Kertas';

  @override
  String get printerAutoPrint => 'Cetak Otomatis Setelah Transaksi';

  @override
  String get printerAutoPrintSubtitle =>
      'Struk langsung dicetak setiap pembayaran berhasil';

  @override
  String get printerTestPrintSuccess => 'Test print terkirim';

  @override
  String get printerTestPrintFailed => 'Gagal mencetak, cek koneksi printer';

  @override
  String get printerTestPrint => 'Test Print';

  @override
  String get printerConnected => 'Terhubung';

  @override
  String get printerNotConnected => 'Tidak ada printer terhubung';

  @override
  String get printerUnnamedDevice => '(Tanpa nama)';

  @override
  String get printerConnectFailed => 'Gagal terhubung ke printer';

  @override
  String get backupCreated => 'Backup berhasil dibuat';

  @override
  String get backupCreateFailed => 'Gagal membuat backup';

  @override
  String get backupImported => 'File backup berhasil diimpor';

  @override
  String get backupImportInvalid => 'File bukan database backup yang valid';

  @override
  String get backupRestoreTitle => 'Pulihkan Database';

  @override
  String backupRestoreConfirm(String fileName, String date) {
    return 'Semua data saat ini akan ditimpa dengan backup \"$fileName\" ($date). Tindakan ini tidak bisa dibatalkan.';
  }

  @override
  String get backupRestoreFailed => 'Gagal memulihkan database';

  @override
  String get backupRestoredTitle => 'Database Dipulihkan';

  @override
  String get backupRestoredBody =>
      'Database berhasil dipulihkan. Silakan login kembali.';

  @override
  String get backupScreenTitle => 'Backup & Restore Database';

  @override
  String get backupNow => 'Backup Sekarang';

  @override
  String get backupDescription =>
      'Menyimpan salinan database saat ini ke penyimpanan lokal perangkat. Gunakan tombol \"Bagikan\" pada tiap backup untuk mengunggah ke Google Drive atau layanan lain.';

  @override
  String get backupImportFile => 'Import File Backup';

  @override
  String get backupHistory => 'Riwayat Backup';

  @override
  String get backupEmpty => 'Belum ada backup';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsLogout => 'Keluar';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => '日本語';
}
