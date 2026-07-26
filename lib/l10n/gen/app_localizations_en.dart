// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonOk => 'OK';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSubtotal => 'Subtotal';

  @override
  String get commonDiscount => 'Discount';

  @override
  String get commonTotal => 'Total';

  @override
  String get commonAll => 'All';

  @override
  String get commonAdmin => 'Admin';

  @override
  String get commonCashier => 'Cashier';

  @override
  String get commonActive => 'Active';

  @override
  String get commonInactive => 'Inactive';

  @override
  String get commonConnect => 'Connect';

  @override
  String get commonDisconnect => 'Disconnect';

  @override
  String get commonRestore => 'Restore';

  @override
  String get commonManual => 'Manual';

  @override
  String get commonImported => 'Imported';

  @override
  String get commonShare => 'Share';

  @override
  String get commonPaidCash => 'Cash';

  @override
  String get commonPaidQris => 'QRIS';

  @override
  String get commonPaidDebit => 'Debit Card';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginUsernameRequired => 'Username is required';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginSubmit => 'Sign In';

  @override
  String get loginWelcome => 'Welcome';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get authInvalidCredentials => 'Incorrect username or password';

  @override
  String get dashboardMenuTitle => 'Main Menu';

  @override
  String get dashboardGreeting => 'Welcome,';

  @override
  String get dashboardSalesToday => 'Today\'s Sales';

  @override
  String get dashboardTransactions => 'Transactions';

  @override
  String get dashboardMenuPos => 'Start Transaction';

  @override
  String get dashboardMenuProducts => 'Manage Products';

  @override
  String get dashboardMenuReports => 'Sales Report';

  @override
  String get dashboardMenuPeriodReports => 'Period Report';

  @override
  String get dashboardMenuUsers => 'Users';

  @override
  String get dashboardMenuPrinter => 'Bluetooth Printer';

  @override
  String get dashboardMenuBackup => 'Backup & Restore';

  @override
  String get dashboardMenuSettings => 'Settings';

  @override
  String get dashboardNotifications => 'Notifications';

  @override
  String dashboardFeatureUnavailable(String feature) {
    return '$feature is not available yet';
  }

  @override
  String get dashboardAccessDenied => 'You don\'t have access to this menu';

  @override
  String get posTitle => 'Cashier Transaction';

  @override
  String get posSearchHint => 'Search product or SKU...';

  @override
  String get posProductNotFound => 'No products found';

  @override
  String get posOutOfStock => 'Insufficient stock';

  @override
  String posStockBadge(int qty) {
    return 'Stock $qty';
  }

  @override
  String get posViewOrder => 'View Order';

  @override
  String get cartCurrentOrder => 'Current Order';

  @override
  String cartItemCount(int count) {
    return '$count item';
  }

  @override
  String get cartEmpty => 'Cart is still empty';

  @override
  String get cartDiscountLabel => 'Discount amount';

  @override
  String get cartCancelTransaction => 'Cancel Transaction';

  @override
  String get cartConfirmClear => 'Clear all items in the cart?';

  @override
  String get cartConfirmCancel => 'Yes, Cancel';

  @override
  String get cartCancelButton => 'Cancel';

  @override
  String cartPay(String amount) {
    return 'Pay $amount';
  }

  @override
  String get paymentTitle => 'Payment';

  @override
  String get paymentTotalBelanja => 'Total Purchase';

  @override
  String get paymentAmountPaid => 'Amount Paid';

  @override
  String get paymentChange => 'Change';

  @override
  String get paymentConfirm => 'Confirm Payment';

  @override
  String get receiptDigitalTitle => 'Digital Receipt';

  @override
  String get receiptSuccess => 'Payment Successful!';

  @override
  String get receiptChangeLabel => 'CHANGE';

  @override
  String get receiptPrint => 'Print Receipt';

  @override
  String get receiptPrinterNotConnected => 'Printer not connected';

  @override
  String get receiptPrintSuccess => 'Receipt printed successfully';

  @override
  String get receiptPrintFailed => 'Failed to print receipt';

  @override
  String get receiptShowDigital => 'Show Digital Receipt';

  @override
  String get receiptNewTransaction => 'New Transaction';

  @override
  String get categoryNewTitle => 'New Category';

  @override
  String get categoryEditTitle => 'Edit Category';

  @override
  String get categoryNameLabel => 'Category name';

  @override
  String get categoryDeleteTitle => 'Delete Category';

  @override
  String categoryDeleteConfirm(String name) {
    return 'Delete \"$name\"? Products using this category will become uncategorized.';
  }

  @override
  String get categoriesTitle => 'Manage Categories';

  @override
  String get categoriesEmpty => 'No categories yet';

  @override
  String get categoryAdd => 'Add Category';

  @override
  String get productFormEditTitle => 'Edit Product';

  @override
  String get productFormAddTitle => 'Add Product';

  @override
  String get productFormName => 'Product Name';

  @override
  String get productFormNameRequired => 'Name is required';

  @override
  String get productFormSku => 'SKU (optional)';

  @override
  String get productFormCategory => 'Category';

  @override
  String get productFormNoCategory => 'No category';

  @override
  String get productFormNewCategory => 'New category';

  @override
  String get productFormPrice => 'Selling Price';

  @override
  String get productFormRequired => 'Required';

  @override
  String get productFormMustBeNumber => 'Must be a number';

  @override
  String get productFormCostPrice => 'Cost Price';

  @override
  String get productFormStock => 'Stock';

  @override
  String get productFormUnit => 'Unit (e.g. pcs)';

  @override
  String get productFormSaveChanges => 'Save Changes';

  @override
  String get productFormCropTitle => 'Adjust Photo';

  @override
  String get productsTitle => 'Product Management';

  @override
  String get productsStockTooltip => 'Manage Stock';

  @override
  String get productsCategoryTooltip => 'Manage Categories';

  @override
  String get productsSearchHint => 'Search product name or SKU...';

  @override
  String get productsEmpty => 'No products yet';

  @override
  String get productsDeleteTitle => 'Delete Product';

  @override
  String productsDeleteConfirm(String name) {
    return 'Delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get productsAdd => 'Add Product';

  @override
  String get stockTitle => 'Manage Stock';

  @override
  String get stockCurrentLabel => 'Current Stock';

  @override
  String get stockAdd => 'Add Stock';

  @override
  String get stockReduce => 'Reduce Stock';

  @override
  String get stockHistoryTitle => 'Stock Movement History';

  @override
  String get stockHistoryEmpty => 'No stock movements yet';

  @override
  String get stockQtyLabel => 'Quantity';

  @override
  String get stockNoteLabel => 'Note (optional)';

  @override
  String get stockMovementIn => 'Stock In';

  @override
  String get stockMovementOut => 'Stock Out (Sale)';

  @override
  String get stockMovementAdjustment => 'Adjustment';

  @override
  String get reportsTitle => 'Daily Report';

  @override
  String get reportsTotalSalesToday => 'Total Sales Today';

  @override
  String reportsChangeVsYesterday(String percent) {
    return '$percent% from yesterday';
  }

  @override
  String get reportsSalesPerHour => 'Sales per Hour';

  @override
  String get reportsNoSalesToday => 'No sales yet today';

  @override
  String get reportsTransactionCount => 'Transaction Count';

  @override
  String reportsTransactionDelta(String delta) {
    return '$delta transactions';
  }

  @override
  String get reportsRecentTransactions => 'Recent Transactions';

  @override
  String get reportsNoTransactions => 'No transactions yet';

  @override
  String reportsTransactionSummary(String time, int count, String method) {
    return '$time · $count item · $method';
  }

  @override
  String get periodTitle => 'Period Report';

  @override
  String get periodWeekly => 'Weekly';

  @override
  String get periodMonthly => 'Monthly';

  @override
  String get periodExportExcel => 'Export to Excel';

  @override
  String get periodExportPdf => 'Export to PDF';

  @override
  String get periodDailyBreakdown => 'Daily Breakdown';

  @override
  String get periodTotalSales => 'TOTAL SALES';

  @override
  String periodChangeVsPrevious(String percent) {
    return '$percent% from last period';
  }

  @override
  String get periodTransactionCount => 'TRANSACTION COUNT';

  @override
  String get periodBestDay => 'BEST DAY';

  @override
  String get periodColDate => 'DAY / DATE';

  @override
  String get periodColTransactions => 'TRANSACTIONS';

  @override
  String get periodColSales => 'SALES';

  @override
  String periodTrxSuffix(int count) {
    return '$count trx';
  }

  @override
  String get periodExportFailed => 'Failed to generate report file';

  @override
  String get periodReportHeading => 'Kasirin Period Report';

  @override
  String get usersTitle => 'User Management';

  @override
  String get usersEmpty => 'No users yet';

  @override
  String get usersAdd => 'Add User';

  @override
  String get usersInactiveSuffix => '· Inactive';

  @override
  String get userDetailTitle => 'User Detail';

  @override
  String get userDetailSaved => 'Changes saved';

  @override
  String get userDetailCantDisableSelf =>
      'You can\'t deactivate your own account';

  @override
  String get userDetailActivateTitle => 'Activate User';

  @override
  String get userDetailDeactivateTitle => 'Deactivate User';

  @override
  String userDetailActivateBody(String name) {
    return '$name will be able to log in again.';
  }

  @override
  String userDetailDeactivateBody(String name) {
    return '$name won\'t be able to log in until reactivated.';
  }

  @override
  String get userDetailActivate => 'Activate';

  @override
  String get userDetailDeactivate => 'Deactivate';

  @override
  String get userDetailRole => 'User Role';

  @override
  String get userDetailPermissions => 'Permissions';

  @override
  String get userDetailSaveChanges => 'Save Changes';

  @override
  String get userFormTitle => 'Add User';

  @override
  String get userFormFullName => 'Full Name';

  @override
  String get userFormUsernameTaken => 'Username is already taken';

  @override
  String get userFormPasswordMinLength => 'At least 6 characters';

  @override
  String get permissionPosTransaction => 'Sales Transactions';

  @override
  String get permissionProductsView => 'View Products';

  @override
  String get permissionProductsManage => 'Manage Products';

  @override
  String get permissionUsersManage => 'Manage Users';

  @override
  String get permissionReportsView => 'View Daily Report';

  @override
  String get permissionDataBackup => 'Backup & Restore Data';

  @override
  String get printerTitle => 'Bluetooth Printer';

  @override
  String get printerPairedDevices => 'Paired Devices';

  @override
  String get printerNoPairedDevices =>
      'No printer paired yet. Pair a printer through your phone\'s Bluetooth settings first, then tap refresh.';

  @override
  String get printerPaperSize => 'Paper Size';

  @override
  String get printerAutoPrint => 'Auto Print After Transaction';

  @override
  String get printerAutoPrintSubtitle =>
      'Receipt prints automatically after every successful payment';

  @override
  String get printerTestPrintSuccess => 'Test print sent';

  @override
  String get printerTestPrintFailed =>
      'Failed to print, check printer connection';

  @override
  String get printerTestPrint => 'Test Print';

  @override
  String get printerConnected => 'Connected';

  @override
  String get printerNotConnected => 'No printer connected';

  @override
  String get printerUnnamedDevice => '(Unnamed)';

  @override
  String get printerConnectFailed => 'Failed to connect to printer';

  @override
  String get backupCreated => 'Backup created successfully';

  @override
  String get backupCreateFailed => 'Failed to create backup';

  @override
  String get backupImported => 'Backup file imported successfully';

  @override
  String get backupImportInvalid => 'File is not a valid backup database';

  @override
  String get backupRestoreTitle => 'Restore Database';

  @override
  String backupRestoreConfirm(String fileName, String date) {
    return 'All current data will be overwritten with the backup \"$fileName\" ($date). This action cannot be undone.';
  }

  @override
  String get backupRestoreFailed => 'Failed to restore database';

  @override
  String get backupRestoredTitle => 'Database Restored';

  @override
  String get backupRestoredBody =>
      'Database restored successfully. Please log in again.';

  @override
  String get backupScreenTitle => 'Backup & Restore Database';

  @override
  String get backupNow => 'Backup Now';

  @override
  String get backupDescription =>
      'Saves a copy of the current database to the device\'s local storage. Use the \"Share\" button on each backup to upload it to Google Drive or another service.';

  @override
  String get backupImportFile => 'Import Backup File';

  @override
  String get backupHistory => 'Backup History';

  @override
  String get backupEmpty => 'No backups yet';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLogout => 'Log Out';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => '日本語';
}
