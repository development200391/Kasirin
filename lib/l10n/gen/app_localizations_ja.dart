// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonSave => '保存';

  @override
  String get commonAdd => '追加';

  @override
  String get commonDelete => '削除';

  @override
  String get commonYes => 'はい';

  @override
  String get commonNo => 'いいえ';

  @override
  String get commonOk => 'OK';

  @override
  String get commonClose => '閉じる';

  @override
  String get commonSubtotal => '小計';

  @override
  String get commonDiscount => '割引';

  @override
  String get commonTotal => '合計';

  @override
  String get commonAll => 'すべて';

  @override
  String get commonAdmin => '管理者';

  @override
  String get commonCashier => 'レジ係';

  @override
  String get commonActive => '有効';

  @override
  String get commonInactive => '無効';

  @override
  String get commonConnect => '接続';

  @override
  String get commonDisconnect => '切断';

  @override
  String get commonRestore => '復元';

  @override
  String get commonManual => '手動';

  @override
  String get commonImported => 'インポート済み';

  @override
  String get commonShare => '共有';

  @override
  String get commonPaidCash => '現金';

  @override
  String get commonPaidQris => 'QRIS';

  @override
  String get commonPaidDebit => 'デビットカード';

  @override
  String get loginUsername => 'ユーザー名';

  @override
  String get loginUsernameRequired => 'ユーザー名を入力してください';

  @override
  String get loginPassword => 'パスワード';

  @override
  String get loginPasswordRequired => 'パスワードを入力してください';

  @override
  String get loginSubmit => 'ログイン';

  @override
  String get loginWelcome => 'ようこそ';

  @override
  String get loginSubtitle => '続けるにはログインしてください';

  @override
  String get authInvalidCredentials => 'ユーザー名またはパスワードが正しくありません';

  @override
  String get dashboardMenuTitle => 'メインメニュー';

  @override
  String get dashboardGreeting => 'ようこそ、';

  @override
  String get dashboardSalesToday => '本日の売上';

  @override
  String get dashboardTransactions => '取引数';

  @override
  String get dashboardMenuPos => '取引を開始';

  @override
  String get dashboardMenuProducts => '商品管理';

  @override
  String get dashboardMenuReports => '売上レポート';

  @override
  String get dashboardMenuPeriodReports => '期間レポート';

  @override
  String get dashboardMenuUsers => 'ユーザー';

  @override
  String get dashboardMenuPrinter => 'Bluetoothプリンター';

  @override
  String get dashboardMenuBackup => 'バックアップと復元';

  @override
  String get dashboardMenuSettings => '設定';

  @override
  String get dashboardNotifications => '通知';

  @override
  String dashboardFeatureUnavailable(String feature) {
    return '$featureはまだ利用できません';
  }

  @override
  String get dashboardAccessDenied => 'このメニューへのアクセス権がありません';

  @override
  String get posTitle => 'レジ取引';

  @override
  String get posSearchHint => '商品名またはSKUで検索...';

  @override
  String get posProductNotFound => '商品が見つかりません';

  @override
  String get posOutOfStock => '在庫が不足しています';

  @override
  String posStockBadge(int qty) {
    return '在庫 $qty';
  }

  @override
  String get posViewOrder => '注文を見る';

  @override
  String get cartCurrentOrder => '現在の注文';

  @override
  String cartItemCount(int count) {
    return '$count点';
  }

  @override
  String get cartEmpty => 'カートはまだ空です';

  @override
  String get cartDiscountLabel => '割引額';

  @override
  String get cartCancelTransaction => '取引をキャンセル';

  @override
  String get cartConfirmClear => 'カート内のすべての商品を削除しますか?';

  @override
  String get cartConfirmCancel => 'はい、キャンセルします';

  @override
  String get cartCancelButton => 'キャンセル';

  @override
  String cartPay(String amount) {
    return '$amountを支払う';
  }

  @override
  String get paymentTitle => '支払い';

  @override
  String get paymentTotalBelanja => '購入合計';

  @override
  String get paymentAmountPaid => '支払金額';

  @override
  String get paymentChange => 'お釣り';

  @override
  String get paymentConfirm => '支払いを確定';

  @override
  String get receiptDigitalTitle => 'デジタルレシート';

  @override
  String get receiptSuccess => '支払いが完了しました!';

  @override
  String get receiptChangeLabel => 'お釣り';

  @override
  String get receiptPrint => 'レシートを印刷';

  @override
  String get receiptPrinterNotConnected => 'プリンターが接続されていません';

  @override
  String get receiptPrintSuccess => 'レシートの印刷に成功しました';

  @override
  String get receiptPrintFailed => 'レシートの印刷に失敗しました';

  @override
  String get receiptShowDigital => 'デジタルレシートを表示';

  @override
  String get receiptNewTransaction => '新しい取引';

  @override
  String get categoryNewTitle => '新しいカテゴリ';

  @override
  String get categoryEditTitle => 'カテゴリを編集';

  @override
  String get categoryNameLabel => 'カテゴリ名';

  @override
  String get categoryDeleteTitle => 'カテゴリを削除';

  @override
  String categoryDeleteConfirm(String name) {
    return '「$name」を削除しますか?このカテゴリを使用している商品はカテゴリなしになります。';
  }

  @override
  String get categoriesTitle => 'カテゴリ管理';

  @override
  String get categoriesEmpty => 'まだカテゴリがありません';

  @override
  String get categoryAdd => 'カテゴリを追加';

  @override
  String get productFormEditTitle => '商品を編集';

  @override
  String get productFormAddTitle => '商品を追加';

  @override
  String get productFormName => '商品名';

  @override
  String get productFormNameRequired => '名前を入力してください';

  @override
  String get productFormSku => 'SKU（任意）';

  @override
  String get productFormCategory => 'カテゴリ';

  @override
  String get productFormNoCategory => 'カテゴリなし';

  @override
  String get productFormNewCategory => '新しいカテゴリ';

  @override
  String get productFormPrice => '販売価格';

  @override
  String get productFormRequired => '必須項目です';

  @override
  String get productFormMustBeNumber => '数値を入力してください';

  @override
  String get productFormCostPrice => '原価';

  @override
  String get productFormStock => '在庫';

  @override
  String get productFormUnit => '単位（例：個）';

  @override
  String get productFormSaveChanges => '変更を保存';

  @override
  String get productFormCropTitle => '写真を調整';

  @override
  String get productsTitle => '商品管理';

  @override
  String get productsStockTooltip => '在庫管理';

  @override
  String get productsCategoryTooltip => 'カテゴリ管理';

  @override
  String get productsSearchHint => '商品名またはSKUで検索...';

  @override
  String get productsEmpty => 'まだ商品がありません';

  @override
  String get productsDeleteTitle => '商品を削除';

  @override
  String productsDeleteConfirm(String name) {
    return '「$name」を削除しますか?この操作は取り消せません。';
  }

  @override
  String get productsAdd => '商品を追加';

  @override
  String get stockTitle => '在庫管理';

  @override
  String get stockCurrentLabel => '現在の在庫';

  @override
  String get stockAdd => '在庫を追加';

  @override
  String get stockReduce => '在庫を減らす';

  @override
  String get stockHistoryTitle => '在庫移動履歴';

  @override
  String get stockHistoryEmpty => 'まだ在庫移動がありません';

  @override
  String get stockQtyLabel => '数量';

  @override
  String get stockNoteLabel => 'メモ（任意）';

  @override
  String get stockMovementIn => '入庫';

  @override
  String get stockMovementOut => '出庫（取引）';

  @override
  String get stockMovementAdjustment => '調整';

  @override
  String get reportsTitle => '日次レポート';

  @override
  String get reportsTotalSalesToday => '本日の売上合計';

  @override
  String reportsChangeVsYesterday(String percent) {
    return '昨日から$percent%';
  }

  @override
  String get reportsSalesPerHour => '時間別売上';

  @override
  String get reportsNoSalesToday => '本日はまだ売上がありません';

  @override
  String get reportsTransactionCount => '取引件数';

  @override
  String reportsTransactionDelta(String delta) {
    return '$delta件';
  }

  @override
  String get reportsRecentTransactions => '最近の取引';

  @override
  String get reportsNoTransactions => 'まだ取引がありません';

  @override
  String reportsTransactionSummary(String time, int count, String method) {
    return '$time・$count点・$method';
  }

  @override
  String get periodTitle => '期間レポート';

  @override
  String get periodWeekly => '週次';

  @override
  String get periodMonthly => '月次';

  @override
  String get periodExportExcel => 'Excelにエクスポート';

  @override
  String get periodExportPdf => 'PDFにエクスポート';

  @override
  String get periodDailyBreakdown => '日別内訳';

  @override
  String get periodTotalSales => '売上合計';

  @override
  String periodChangeVsPrevious(String percent) {
    return '前期間から$percent%';
  }

  @override
  String get periodTransactionCount => '取引件数';

  @override
  String get periodBestDay => 'ベストデー';

  @override
  String get periodColDate => '曜日・日付';

  @override
  String get periodColTransactions => '取引';

  @override
  String get periodColSales => '売上';

  @override
  String periodTrxSuffix(int count) {
    return '$count件';
  }

  @override
  String get periodExportFailed => 'レポートファイルの作成に失敗しました';

  @override
  String get periodReportHeading => 'Kasirin期間レポート';

  @override
  String get usersTitle => 'ユーザー管理';

  @override
  String get usersEmpty => 'まだユーザーがいません';

  @override
  String get usersAdd => 'ユーザーを追加';

  @override
  String get usersInactiveSuffix => '・無効';

  @override
  String get userDetailTitle => 'ユーザー詳細';

  @override
  String get userDetailSaved => '変更が保存されました';

  @override
  String get userDetailCantDisableSelf => '自分のアカウントを無効にすることはできません';

  @override
  String get userDetailActivateTitle => 'ユーザーを有効化';

  @override
  String get userDetailDeactivateTitle => 'ユーザーを無効化';

  @override
  String userDetailActivateBody(String name) {
    return '$nameは再びログインできるようになります。';
  }

  @override
  String userDetailDeactivateBody(String name) {
    return '$nameは再度有効化されるまでログインできません。';
  }

  @override
  String get userDetailActivate => '有効化';

  @override
  String get userDetailDeactivate => '無効化';

  @override
  String get userDetailRole => 'ユーザーロール';

  @override
  String get userDetailPermissions => '権限';

  @override
  String get userDetailSaveChanges => '変更を保存';

  @override
  String get userFormTitle => 'ユーザーを追加';

  @override
  String get userFormFullName => '氏名';

  @override
  String get userFormUsernameTaken => 'このユーザー名は既に使用されています';

  @override
  String get userFormPasswordMinLength => '6文字以上で入力してください';

  @override
  String get permissionPosTransaction => '販売取引';

  @override
  String get permissionProductsView => '商品を見る';

  @override
  String get permissionProductsManage => '商品管理';

  @override
  String get permissionUsersManage => 'ユーザー管理';

  @override
  String get permissionReportsView => '日次レポートを見る';

  @override
  String get permissionDataBackup => 'データのバックアップと復元';

  @override
  String get printerTitle => 'Bluetoothプリンター';

  @override
  String get printerPairedDevices => 'ペアリング済みデバイス';

  @override
  String get printerNoPairedDevices =>
      'ペアリング済みのプリンターがありません。先に端末のBluetooth設定でプリンターとペアリングしてから、更新ボタンを押してください。';

  @override
  String get printerPaperSize => '用紙サイズ';

  @override
  String get printerAutoPrint => '取引後に自動印刷';

  @override
  String get printerAutoPrintSubtitle => '支払い成功時にレシートを自動的に印刷します';

  @override
  String get printerTestPrintSuccess => 'テスト印刷を送信しました';

  @override
  String get printerTestPrintFailed => '印刷に失敗しました。プリンターの接続を確認してください';

  @override
  String get printerTestPrint => 'テスト印刷';

  @override
  String get printerConnected => '接続済み';

  @override
  String get printerNotConnected => '接続されているプリンターがありません';

  @override
  String get printerUnnamedDevice => '（名前なし）';

  @override
  String get printerConnectFailed => 'プリンターへの接続に失敗しました';

  @override
  String get backupCreated => 'バックアップの作成に成功しました';

  @override
  String get backupCreateFailed => 'バックアップの作成に失敗しました';

  @override
  String get backupImported => 'バックアップファイルのインポートに成功しました';

  @override
  String get backupImportInvalid => '有効なバックアップデータベースファイルではありません';

  @override
  String get backupRestoreTitle => 'データベースを復元';

  @override
  String backupRestoreConfirm(String fileName, String date) {
    return '現在のすべてのデータがバックアップ「$fileName」（$date）で上書きされます。この操作は取り消せません。';
  }

  @override
  String get backupRestoreFailed => 'データベースの復元に失敗しました';

  @override
  String get backupRestoredTitle => 'データベースが復元されました';

  @override
  String get backupRestoredBody => 'データベースの復元が完了しました。再度ログインしてください。';

  @override
  String get backupScreenTitle => 'バックアップと復元';

  @override
  String get backupNow => '今すぐバックアップ';

  @override
  String get backupDescription =>
      '現在のデータベースのコピーを端末のローカルストレージに保存します。各バックアップの「共有」ボタンを使ってGoogle Driveなど他のサービスにアップロードできます。';

  @override
  String get backupImportFile => 'バックアップファイルをインポート';

  @override
  String get backupHistory => 'バックアップ履歴';

  @override
  String get backupEmpty => 'まだバックアップがありません';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsLogout => 'ログアウト';

  @override
  String get settingsLanguage => '言語';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageJapanese => '日本語';
}
