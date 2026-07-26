import '../l10n/gen/app_localizations.dart';

class AppPermissions {
  static const posTransaction = 'pos.transaction';
  static const productsView = 'products.view';
  static const productsManage = 'products.manage';
  static const usersManage = 'users.manage';
  static const reportsView = 'reports.view';
  static const dataBackup = 'data.backup';

  static const all = [
    posTransaction,
    productsView,
    productsManage,
    usersManage,
    reportsView,
    dataBackup,
  ];

  static String label(String permission, AppLocalizations l10n) {
    return switch (permission) {
      posTransaction => l10n.permissionPosTransaction,
      productsView => l10n.permissionProductsView,
      productsManage => l10n.permissionProductsManage,
      usersManage => l10n.permissionUsersManage,
      reportsView => l10n.permissionReportsView,
      dataBackup => l10n.permissionDataBackup,
      _ => permission,
    };
  }

  static List<String> defaultsForRole(String role) {
    if (role == 'admin') return List.of(all);
    return [posTransaction, productsView];
  }

  static List<String> parse(String? csv) {
    if (csv == null || csv.trim().isEmpty) return [];
    return csv.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  static String encode(List<String> permissions) => permissions.join(',');
}
