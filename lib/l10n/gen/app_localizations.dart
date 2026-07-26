import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ja'),
  ];

  /// No description provided for @commonCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get commonSave;

  /// No description provided for @commonAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah'**
  String get commonAdd;

  /// No description provided for @commonDelete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get commonDelete;

  /// No description provided for @commonYes.
  ///
  /// In id, this message translates to:
  /// **'Ya'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In id, this message translates to:
  /// **'Tidak'**
  String get commonNo;

  /// No description provided for @commonOk.
  ///
  /// In id, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonClose.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get commonClose;

  /// No description provided for @commonSubtotal.
  ///
  /// In id, this message translates to:
  /// **'Subtotal'**
  String get commonSubtotal;

  /// No description provided for @commonDiscount.
  ///
  /// In id, this message translates to:
  /// **'Diskon'**
  String get commonDiscount;

  /// No description provided for @commonTotal.
  ///
  /// In id, this message translates to:
  /// **'Total'**
  String get commonTotal;

  /// No description provided for @commonAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get commonAll;

  /// No description provided for @commonAdmin.
  ///
  /// In id, this message translates to:
  /// **'Admin'**
  String get commonAdmin;

  /// No description provided for @commonCashier.
  ///
  /// In id, this message translates to:
  /// **'Kasir'**
  String get commonCashier;

  /// No description provided for @commonActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get commonActive;

  /// No description provided for @commonInactive.
  ///
  /// In id, this message translates to:
  /// **'Nonaktif'**
  String get commonInactive;

  /// No description provided for @commonConnect.
  ///
  /// In id, this message translates to:
  /// **'Hubungkan'**
  String get commonConnect;

  /// No description provided for @commonDisconnect.
  ///
  /// In id, this message translates to:
  /// **'Putuskan'**
  String get commonDisconnect;

  /// No description provided for @commonRestore.
  ///
  /// In id, this message translates to:
  /// **'Pulihkan'**
  String get commonRestore;

  /// No description provided for @commonManual.
  ///
  /// In id, this message translates to:
  /// **'Manual'**
  String get commonManual;

  /// No description provided for @commonImported.
  ///
  /// In id, this message translates to:
  /// **'Diimpor'**
  String get commonImported;

  /// No description provided for @commonShare.
  ///
  /// In id, this message translates to:
  /// **'Bagikan'**
  String get commonShare;

  /// No description provided for @commonPaidCash.
  ///
  /// In id, this message translates to:
  /// **'Tunai'**
  String get commonPaidCash;

  /// No description provided for @commonPaidQris.
  ///
  /// In id, this message translates to:
  /// **'QRIS'**
  String get commonPaidQris;

  /// No description provided for @commonPaidDebit.
  ///
  /// In id, this message translates to:
  /// **'Kartu Debit'**
  String get commonPaidDebit;

  /// No description provided for @loginUsername.
  ///
  /// In id, this message translates to:
  /// **'Username'**
  String get loginUsername;

  /// No description provided for @loginUsernameRequired.
  ///
  /// In id, this message translates to:
  /// **'Username wajib diisi'**
  String get loginUsernameRequired;

  /// No description provided for @loginPassword.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get loginPassword;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi wajib diisi'**
  String get loginPasswordRequired;

  /// No description provided for @loginSubmit.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginSubmit;

  /// No description provided for @loginWelcome.
  ///
  /// In id, this message translates to:
  /// **'Selamat Datang'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk untuk melanjutkan'**
  String get loginSubtitle;

  /// No description provided for @authInvalidCredentials.
  ///
  /// In id, this message translates to:
  /// **'Username atau kata sandi salah'**
  String get authInvalidCredentials;

  /// No description provided for @dashboardMenuTitle.
  ///
  /// In id, this message translates to:
  /// **'Menu Utama'**
  String get dashboardMenuTitle;

  /// No description provided for @dashboardGreeting.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang,'**
  String get dashboardGreeting;

  /// No description provided for @dashboardSalesToday.
  ///
  /// In id, this message translates to:
  /// **'Penjualan Hari Ini'**
  String get dashboardSalesToday;

  /// No description provided for @dashboardTransactions.
  ///
  /// In id, this message translates to:
  /// **'Transaksi'**
  String get dashboardTransactions;

  /// No description provided for @dashboardMenuPos.
  ///
  /// In id, this message translates to:
  /// **'Mulai Transaksi'**
  String get dashboardMenuPos;

  /// No description provided for @dashboardMenuProducts.
  ///
  /// In id, this message translates to:
  /// **'Kelola Produk'**
  String get dashboardMenuProducts;

  /// No description provided for @dashboardMenuReports.
  ///
  /// In id, this message translates to:
  /// **'Laporan Penjualan'**
  String get dashboardMenuReports;

  /// No description provided for @dashboardMenuPeriodReports.
  ///
  /// In id, this message translates to:
  /// **'Laporan Periode'**
  String get dashboardMenuPeriodReports;

  /// No description provided for @dashboardMenuUsers.
  ///
  /// In id, this message translates to:
  /// **'Pengguna'**
  String get dashboardMenuUsers;

  /// No description provided for @dashboardMenuPrinter.
  ///
  /// In id, this message translates to:
  /// **'Printer Bluetooth'**
  String get dashboardMenuPrinter;

  /// No description provided for @dashboardMenuBackup.
  ///
  /// In id, this message translates to:
  /// **'Backup & Restore'**
  String get dashboardMenuBackup;

  /// No description provided for @dashboardMenuSettings.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get dashboardMenuSettings;

  /// No description provided for @dashboardNotifications.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi'**
  String get dashboardNotifications;

  /// No description provided for @dashboardFeatureUnavailable.
  ///
  /// In id, this message translates to:
  /// **'{feature} belum tersedia'**
  String dashboardFeatureUnavailable(String feature);

  /// No description provided for @dashboardAccessDenied.
  ///
  /// In id, this message translates to:
  /// **'Anda tidak memiliki akses ke menu ini'**
  String get dashboardAccessDenied;

  /// No description provided for @posTitle.
  ///
  /// In id, this message translates to:
  /// **'Transaksi Kasir'**
  String get posTitle;

  /// No description provided for @posSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari produk atau SKU...'**
  String get posSearchHint;

  /// No description provided for @posProductNotFound.
  ///
  /// In id, this message translates to:
  /// **'Produk tidak ditemukan'**
  String get posProductNotFound;

  /// No description provided for @posOutOfStock.
  ///
  /// In id, this message translates to:
  /// **'Stok tidak mencukupi'**
  String get posOutOfStock;

  /// No description provided for @posStockBadge.
  ///
  /// In id, this message translates to:
  /// **'Stok {qty}'**
  String posStockBadge(int qty);

  /// No description provided for @posViewOrder.
  ///
  /// In id, this message translates to:
  /// **'Lihat Pesanan'**
  String get posViewOrder;

  /// No description provided for @cartCurrentOrder.
  ///
  /// In id, this message translates to:
  /// **'Pesanan Saat Ini'**
  String get cartCurrentOrder;

  /// No description provided for @cartItemCount.
  ///
  /// In id, this message translates to:
  /// **'{count} item'**
  String cartItemCount(int count);

  /// No description provided for @cartEmpty.
  ///
  /// In id, this message translates to:
  /// **'Keranjang masih kosong'**
  String get cartEmpty;

  /// No description provided for @cartDiscountLabel.
  ///
  /// In id, this message translates to:
  /// **'Jumlah diskon'**
  String get cartDiscountLabel;

  /// No description provided for @cartCancelTransaction.
  ///
  /// In id, this message translates to:
  /// **'Batalkan Transaksi'**
  String get cartCancelTransaction;

  /// No description provided for @cartConfirmClear.
  ///
  /// In id, this message translates to:
  /// **'Kosongkan semua item di keranjang?'**
  String get cartConfirmClear;

  /// No description provided for @cartConfirmCancel.
  ///
  /// In id, this message translates to:
  /// **'Ya, Batalkan'**
  String get cartConfirmCancel;

  /// No description provided for @cartCancelButton.
  ///
  /// In id, this message translates to:
  /// **'Batalkan'**
  String get cartCancelButton;

  /// No description provided for @cartPay.
  ///
  /// In id, this message translates to:
  /// **'Bayar {amount}'**
  String cartPay(String amount);

  /// No description provided for @paymentTitle.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran'**
  String get paymentTitle;

  /// No description provided for @paymentTotalBelanja.
  ///
  /// In id, this message translates to:
  /// **'Total Belanja'**
  String get paymentTotalBelanja;

  /// No description provided for @paymentAmountPaid.
  ///
  /// In id, this message translates to:
  /// **'Uang Bayar'**
  String get paymentAmountPaid;

  /// No description provided for @paymentChange.
  ///
  /// In id, this message translates to:
  /// **'Kembalian'**
  String get paymentChange;

  /// No description provided for @paymentConfirm.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Bayar'**
  String get paymentConfirm;

  /// No description provided for @receiptDigitalTitle.
  ///
  /// In id, this message translates to:
  /// **'Struk Digital'**
  String get receiptDigitalTitle;

  /// No description provided for @receiptSuccess.
  ///
  /// In id, this message translates to:
  /// **'Pembayaran Berhasil!'**
  String get receiptSuccess;

  /// No description provided for @receiptChangeLabel.
  ///
  /// In id, this message translates to:
  /// **'KEMBALIAN'**
  String get receiptChangeLabel;

  /// No description provided for @receiptPrint.
  ///
  /// In id, this message translates to:
  /// **'Cetak Struk'**
  String get receiptPrint;

  /// No description provided for @receiptPrinterNotConnected.
  ///
  /// In id, this message translates to:
  /// **'Printer belum terhubung'**
  String get receiptPrinterNotConnected;

  /// No description provided for @receiptPrintSuccess.
  ///
  /// In id, this message translates to:
  /// **'Struk berhasil dicetak'**
  String get receiptPrintSuccess;

  /// No description provided for @receiptPrintFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mencetak struk'**
  String get receiptPrintFailed;

  /// No description provided for @receiptShowDigital.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan Struk Digital'**
  String get receiptShowDigital;

  /// No description provided for @receiptNewTransaction.
  ///
  /// In id, this message translates to:
  /// **'Transaksi Baru'**
  String get receiptNewTransaction;

  /// No description provided for @categoryNewTitle.
  ///
  /// In id, this message translates to:
  /// **'Kategori Baru'**
  String get categoryNewTitle;

  /// No description provided for @categoryEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Ubah Kategori'**
  String get categoryEditTitle;

  /// No description provided for @categoryNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama kategori'**
  String get categoryNameLabel;

  /// No description provided for @categoryDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Kategori'**
  String get categoryDeleteTitle;

  /// No description provided for @categoryDeleteConfirm.
  ///
  /// In id, this message translates to:
  /// **'Hapus \"{name}\"? Produk yang memakai kategori ini akan menjadi tanpa kategori.'**
  String categoryDeleteConfirm(String name);

  /// No description provided for @categoriesTitle.
  ///
  /// In id, this message translates to:
  /// **'Kelola Kategori'**
  String get categoriesTitle;

  /// No description provided for @categoriesEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada kategori'**
  String get categoriesEmpty;

  /// No description provided for @categoryAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Kategori'**
  String get categoryAdd;

  /// No description provided for @productFormEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Produk'**
  String get productFormEditTitle;

  /// No description provided for @productFormAddTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Produk'**
  String get productFormAddTitle;

  /// No description provided for @productFormName.
  ///
  /// In id, this message translates to:
  /// **'Nama Produk'**
  String get productFormName;

  /// No description provided for @productFormNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama wajib diisi'**
  String get productFormNameRequired;

  /// No description provided for @productFormSku.
  ///
  /// In id, this message translates to:
  /// **'SKU (opsional)'**
  String get productFormSku;

  /// No description provided for @productFormCategory.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get productFormCategory;

  /// No description provided for @productFormNoCategory.
  ///
  /// In id, this message translates to:
  /// **'Tanpa kategori'**
  String get productFormNoCategory;

  /// No description provided for @productFormNewCategory.
  ///
  /// In id, this message translates to:
  /// **'Kategori baru'**
  String get productFormNewCategory;

  /// No description provided for @productFormPrice.
  ///
  /// In id, this message translates to:
  /// **'Harga Jual'**
  String get productFormPrice;

  /// No description provided for @productFormRequired.
  ///
  /// In id, this message translates to:
  /// **'Wajib diisi'**
  String get productFormRequired;

  /// No description provided for @productFormMustBeNumber.
  ///
  /// In id, this message translates to:
  /// **'Harus angka'**
  String get productFormMustBeNumber;

  /// No description provided for @productFormCostPrice.
  ///
  /// In id, this message translates to:
  /// **'Harga Modal'**
  String get productFormCostPrice;

  /// No description provided for @productFormStock.
  ///
  /// In id, this message translates to:
  /// **'Stok'**
  String get productFormStock;

  /// No description provided for @productFormUnit.
  ///
  /// In id, this message translates to:
  /// **'Satuan (mis. pcs)'**
  String get productFormUnit;

  /// No description provided for @productFormSaveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan'**
  String get productFormSaveChanges;

  /// No description provided for @productFormCropTitle.
  ///
  /// In id, this message translates to:
  /// **'Sesuaikan Foto'**
  String get productFormCropTitle;

  /// No description provided for @productsTitle.
  ///
  /// In id, this message translates to:
  /// **'Manajemen Produk'**
  String get productsTitle;

  /// No description provided for @productsStockTooltip.
  ///
  /// In id, this message translates to:
  /// **'Manajemen Stok'**
  String get productsStockTooltip;

  /// No description provided for @productsCategoryTooltip.
  ///
  /// In id, this message translates to:
  /// **'Kelola Kategori'**
  String get productsCategoryTooltip;

  /// No description provided for @productsSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari nama produk atau SKU...'**
  String get productsSearchHint;

  /// No description provided for @productsEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada produk'**
  String get productsEmpty;

  /// No description provided for @productsDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Produk'**
  String get productsDeleteTitle;

  /// No description provided for @productsDeleteConfirm.
  ///
  /// In id, this message translates to:
  /// **'Hapus \"{name}\"? Tindakan ini tidak bisa dibatalkan.'**
  String productsDeleteConfirm(String name);

  /// No description provided for @productsAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Produk'**
  String get productsAdd;

  /// No description provided for @stockTitle.
  ///
  /// In id, this message translates to:
  /// **'Manajemen Stok'**
  String get stockTitle;

  /// No description provided for @stockCurrentLabel.
  ///
  /// In id, this message translates to:
  /// **'Stok Saat Ini'**
  String get stockCurrentLabel;

  /// No description provided for @stockAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Stok'**
  String get stockAdd;

  /// No description provided for @stockReduce.
  ///
  /// In id, this message translates to:
  /// **'Kurangi Stok'**
  String get stockReduce;

  /// No description provided for @stockHistoryTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Pergerakan Stok'**
  String get stockHistoryTitle;

  /// No description provided for @stockHistoryEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pergerakan stok'**
  String get stockHistoryEmpty;

  /// No description provided for @stockQtyLabel.
  ///
  /// In id, this message translates to:
  /// **'Jumlah'**
  String get stockQtyLabel;

  /// No description provided for @stockNoteLabel.
  ///
  /// In id, this message translates to:
  /// **'Catatan (opsional)'**
  String get stockNoteLabel;

  /// No description provided for @stockMovementIn.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get stockMovementIn;

  /// No description provided for @stockMovementOut.
  ///
  /// In id, this message translates to:
  /// **'Keluar (Transaksi)'**
  String get stockMovementOut;

  /// No description provided for @stockMovementAdjustment.
  ///
  /// In id, this message translates to:
  /// **'Penyesuaian'**
  String get stockMovementAdjustment;

  /// No description provided for @reportsTitle.
  ///
  /// In id, this message translates to:
  /// **'Laporan Harian'**
  String get reportsTitle;

  /// No description provided for @reportsTotalSalesToday.
  ///
  /// In id, this message translates to:
  /// **'Total Penjualan Hari Ini'**
  String get reportsTotalSalesToday;

  /// No description provided for @reportsChangeVsYesterday.
  ///
  /// In id, this message translates to:
  /// **'{percent}% dari kemarin'**
  String reportsChangeVsYesterday(String percent);

  /// No description provided for @reportsSalesPerHour.
  ///
  /// In id, this message translates to:
  /// **'Penjualan per Jam'**
  String get reportsSalesPerHour;

  /// No description provided for @reportsNoSalesToday.
  ///
  /// In id, this message translates to:
  /// **'Belum ada penjualan hari ini'**
  String get reportsNoSalesToday;

  /// No description provided for @reportsTransactionCount.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Transaksi'**
  String get reportsTransactionCount;

  /// No description provided for @reportsTransactionDelta.
  ///
  /// In id, this message translates to:
  /// **'{delta} transaksi'**
  String reportsTransactionDelta(String delta);

  /// No description provided for @reportsRecentTransactions.
  ///
  /// In id, this message translates to:
  /// **'Transaksi Terbaru'**
  String get reportsRecentTransactions;

  /// No description provided for @reportsNoTransactions.
  ///
  /// In id, this message translates to:
  /// **'Belum ada transaksi'**
  String get reportsNoTransactions;

  /// No description provided for @reportsTransactionSummary.
  ///
  /// In id, this message translates to:
  /// **'{time} · {count} item · {method}'**
  String reportsTransactionSummary(String time, int count, String method);

  /// No description provided for @periodTitle.
  ///
  /// In id, this message translates to:
  /// **'Laporan Periode'**
  String get periodTitle;

  /// No description provided for @periodWeekly.
  ///
  /// In id, this message translates to:
  /// **'Mingguan'**
  String get periodWeekly;

  /// No description provided for @periodMonthly.
  ///
  /// In id, this message translates to:
  /// **'Bulanan'**
  String get periodMonthly;

  /// No description provided for @periodExportExcel.
  ///
  /// In id, this message translates to:
  /// **'Export ke Excel'**
  String get periodExportExcel;

  /// No description provided for @periodExportPdf.
  ///
  /// In id, this message translates to:
  /// **'Export ke PDF'**
  String get periodExportPdf;

  /// No description provided for @periodDailyBreakdown.
  ///
  /// In id, this message translates to:
  /// **'Rincian per Hari'**
  String get periodDailyBreakdown;

  /// No description provided for @periodTotalSales.
  ///
  /// In id, this message translates to:
  /// **'TOTAL PENJUALAN'**
  String get periodTotalSales;

  /// No description provided for @periodChangeVsPrevious.
  ///
  /// In id, this message translates to:
  /// **'{percent}% dari periode lalu'**
  String periodChangeVsPrevious(String percent);

  /// No description provided for @periodTransactionCount.
  ///
  /// In id, this message translates to:
  /// **'JUMLAH TRANSAKSI'**
  String get periodTransactionCount;

  /// No description provided for @periodBestDay.
  ///
  /// In id, this message translates to:
  /// **'HARI TERBAIK'**
  String get periodBestDay;

  /// No description provided for @periodColDate.
  ///
  /// In id, this message translates to:
  /// **'HARI / TANGGAL'**
  String get periodColDate;

  /// No description provided for @periodColTransactions.
  ///
  /// In id, this message translates to:
  /// **'TRANSAKSI'**
  String get periodColTransactions;

  /// No description provided for @periodColSales.
  ///
  /// In id, this message translates to:
  /// **'PENJUALAN'**
  String get periodColSales;

  /// No description provided for @periodTrxSuffix.
  ///
  /// In id, this message translates to:
  /// **'{count} trx'**
  String periodTrxSuffix(int count);

  /// No description provided for @periodExportFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat file laporan'**
  String get periodExportFailed;

  /// No description provided for @periodReportHeading.
  ///
  /// In id, this message translates to:
  /// **'Laporan Periode Kasirin'**
  String get periodReportHeading;

  /// No description provided for @usersTitle.
  ///
  /// In id, this message translates to:
  /// **'Manajemen Pengguna'**
  String get usersTitle;

  /// No description provided for @usersEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pengguna'**
  String get usersEmpty;

  /// No description provided for @usersAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Pengguna'**
  String get usersAdd;

  /// No description provided for @usersInactiveSuffix.
  ///
  /// In id, this message translates to:
  /// **'· Nonaktif'**
  String get usersInactiveSuffix;

  /// No description provided for @userDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Detail Pengguna'**
  String get userDetailTitle;

  /// No description provided for @userDetailSaved.
  ///
  /// In id, this message translates to:
  /// **'Perubahan disimpan'**
  String get userDetailSaved;

  /// No description provided for @userDetailCantDisableSelf.
  ///
  /// In id, this message translates to:
  /// **'Anda tidak bisa menonaktifkan akun sendiri'**
  String get userDetailCantDisableSelf;

  /// No description provided for @userDetailActivateTitle.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan Pengguna'**
  String get userDetailActivateTitle;

  /// No description provided for @userDetailDeactivateTitle.
  ///
  /// In id, this message translates to:
  /// **'Nonaktifkan Pengguna'**
  String get userDetailDeactivateTitle;

  /// No description provided for @userDetailActivateBody.
  ///
  /// In id, this message translates to:
  /// **'{name} akan bisa login kembali.'**
  String userDetailActivateBody(String name);

  /// No description provided for @userDetailDeactivateBody.
  ///
  /// In id, this message translates to:
  /// **'{name} tidak akan bisa login sampai diaktifkan kembali.'**
  String userDetailDeactivateBody(String name);

  /// No description provided for @userDetailActivate.
  ///
  /// In id, this message translates to:
  /// **'Aktifkan'**
  String get userDetailActivate;

  /// No description provided for @userDetailDeactivate.
  ///
  /// In id, this message translates to:
  /// **'Nonaktifkan'**
  String get userDetailDeactivate;

  /// No description provided for @userDetailRole.
  ///
  /// In id, this message translates to:
  /// **'Role Pengguna'**
  String get userDetailRole;

  /// No description provided for @userDetailPermissions.
  ///
  /// In id, this message translates to:
  /// **'Hak Akses'**
  String get userDetailPermissions;

  /// No description provided for @userDetailSaveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan'**
  String get userDetailSaveChanges;

  /// No description provided for @userFormTitle.
  ///
  /// In id, this message translates to:
  /// **'Tambah Pengguna'**
  String get userFormTitle;

  /// No description provided for @userFormFullName.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get userFormFullName;

  /// No description provided for @userFormUsernameTaken.
  ///
  /// In id, this message translates to:
  /// **'Username sudah dipakai'**
  String get userFormUsernameTaken;

  /// No description provided for @userFormPasswordMinLength.
  ///
  /// In id, this message translates to:
  /// **'Minimal 6 karakter'**
  String get userFormPasswordMinLength;

  /// No description provided for @permissionPosTransaction.
  ///
  /// In id, this message translates to:
  /// **'Transaksi Penjualan'**
  String get permissionPosTransaction;

  /// No description provided for @permissionProductsView.
  ///
  /// In id, this message translates to:
  /// **'Lihat Produk'**
  String get permissionProductsView;

  /// No description provided for @permissionProductsManage.
  ///
  /// In id, this message translates to:
  /// **'Kelola Produk'**
  String get permissionProductsManage;

  /// No description provided for @permissionUsersManage.
  ///
  /// In id, this message translates to:
  /// **'Kelola Pengguna'**
  String get permissionUsersManage;

  /// No description provided for @permissionReportsView.
  ///
  /// In id, this message translates to:
  /// **'Lihat Laporan Harian'**
  String get permissionReportsView;

  /// No description provided for @permissionDataBackup.
  ///
  /// In id, this message translates to:
  /// **'Backup & Restore Data'**
  String get permissionDataBackup;

  /// No description provided for @printerTitle.
  ///
  /// In id, this message translates to:
  /// **'Printer Bluetooth'**
  String get printerTitle;

  /// No description provided for @printerPairedDevices.
  ///
  /// In id, this message translates to:
  /// **'Perangkat Berpasangan'**
  String get printerPairedDevices;

  /// No description provided for @printerNoPairedDevices.
  ///
  /// In id, this message translates to:
  /// **'Belum ada printer yang dipasangkan. Pasangkan printer melalui pengaturan Bluetooth HP terlebih dahulu, lalu tekan refresh.'**
  String get printerNoPairedDevices;

  /// No description provided for @printerPaperSize.
  ///
  /// In id, this message translates to:
  /// **'Ukuran Kertas'**
  String get printerPaperSize;

  /// No description provided for @printerAutoPrint.
  ///
  /// In id, this message translates to:
  /// **'Cetak Otomatis Setelah Transaksi'**
  String get printerAutoPrint;

  /// No description provided for @printerAutoPrintSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Struk langsung dicetak setiap pembayaran berhasil'**
  String get printerAutoPrintSubtitle;

  /// No description provided for @printerTestPrintSuccess.
  ///
  /// In id, this message translates to:
  /// **'Test print terkirim'**
  String get printerTestPrintSuccess;

  /// No description provided for @printerTestPrintFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mencetak, cek koneksi printer'**
  String get printerTestPrintFailed;

  /// No description provided for @printerTestPrint.
  ///
  /// In id, this message translates to:
  /// **'Test Print'**
  String get printerTestPrint;

  /// No description provided for @printerConnected.
  ///
  /// In id, this message translates to:
  /// **'Terhubung'**
  String get printerConnected;

  /// No description provided for @printerNotConnected.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada printer terhubung'**
  String get printerNotConnected;

  /// No description provided for @printerUnnamedDevice.
  ///
  /// In id, this message translates to:
  /// **'(Tanpa nama)'**
  String get printerUnnamedDevice;

  /// No description provided for @printerConnectFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal terhubung ke printer'**
  String get printerConnectFailed;

  /// No description provided for @backupCreated.
  ///
  /// In id, this message translates to:
  /// **'Backup berhasil dibuat'**
  String get backupCreated;

  /// No description provided for @backupCreateFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal membuat backup'**
  String get backupCreateFailed;

  /// No description provided for @backupImported.
  ///
  /// In id, this message translates to:
  /// **'File backup berhasil diimpor'**
  String get backupImported;

  /// No description provided for @backupImportInvalid.
  ///
  /// In id, this message translates to:
  /// **'File bukan database backup yang valid'**
  String get backupImportInvalid;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In id, this message translates to:
  /// **'Pulihkan Database'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreConfirm.
  ///
  /// In id, this message translates to:
  /// **'Semua data saat ini akan ditimpa dengan backup \"{fileName}\" ({date}). Tindakan ini tidak bisa dibatalkan.'**
  String backupRestoreConfirm(String fileName, String date);

  /// No description provided for @backupRestoreFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memulihkan database'**
  String get backupRestoreFailed;

  /// No description provided for @backupRestoredTitle.
  ///
  /// In id, this message translates to:
  /// **'Database Dipulihkan'**
  String get backupRestoredTitle;

  /// No description provided for @backupRestoredBody.
  ///
  /// In id, this message translates to:
  /// **'Database berhasil dipulihkan. Silakan login kembali.'**
  String get backupRestoredBody;

  /// No description provided for @backupScreenTitle.
  ///
  /// In id, this message translates to:
  /// **'Backup & Restore Database'**
  String get backupScreenTitle;

  /// No description provided for @backupNow.
  ///
  /// In id, this message translates to:
  /// **'Backup Sekarang'**
  String get backupNow;

  /// No description provided for @backupDescription.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan salinan database saat ini ke penyimpanan lokal perangkat. Gunakan tombol \"Bagikan\" pada tiap backup untuk mengunggah ke Google Drive atau layanan lain.'**
  String get backupDescription;

  /// No description provided for @backupImportFile.
  ///
  /// In id, this message translates to:
  /// **'Import File Backup'**
  String get backupImportFile;

  /// No description provided for @backupHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Backup'**
  String get backupHistory;

  /// No description provided for @backupEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada backup'**
  String get backupEmpty;

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @settingsLogout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get settingsLogout;

  /// No description provided for @settingsLanguage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get settingsLanguage;

  /// No description provided for @languageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageJapanese.
  ///
  /// In id, this message translates to:
  /// **'日本語'**
  String get languageJapanese;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
