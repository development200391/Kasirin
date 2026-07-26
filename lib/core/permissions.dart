class AppPermissions {
  static const posTransaction = 'pos.transaction';
  static const productsView = 'products.view';
  static const productsManage = 'products.manage';
  static const usersManage = 'users.manage';
  static const reportsView = 'reports.view';

  static const all = [
    posTransaction,
    productsView,
    productsManage,
    usersManage,
    reportsView,
  ];

  static const labels = {
    posTransaction: 'Transaksi Penjualan',
    productsView: 'Lihat Produk',
    productsManage: 'Kelola Produk',
    usersManage: 'Kelola Pengguna',
    reportsView: 'Lihat Laporan Harian',
  };

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
