import '../db/database_helper.dart';

class DashboardSummary {
  final int totalSales;
  final int transactionCount;

  const DashboardSummary({required this.totalSales, required this.transactionCount});
}

class DashboardRepository {
  Future<DashboardSummary> getTodaySummary() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.rawQuery('''
      SELECT
        COALESCE(SUM(CASE WHEN status = 'paid' THEN total_amount ELSE 0 END), 0) AS total_sales,
        COUNT(*) AS transaction_count
      FROM transactions
      WHERE date(created_at) = date('now', 'localtime')
    ''');

    final row = rows.first;
    return DashboardSummary(
      totalSales: row['total_sales'] as int,
      transactionCount: row['transaction_count'] as int,
    );
  }
}
