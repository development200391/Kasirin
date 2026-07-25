import '../db/database_helper.dart';
import '../models/daily_report.dart';

class ReportRepository {
  Future<DailyReport> getDailyReport() async {
    final db = await DatabaseHelper.instance.database;

    final todayRow = (await db.rawQuery('''
      SELECT
        COALESCE(SUM(CASE WHEN status = 'paid' THEN total_amount ELSE 0 END), 0) AS total_sales,
        COUNT(*) AS transaction_count
      FROM transactions
      WHERE date(created_at) = date('now', 'localtime')
    ''')).first;

    final yesterdayRow = (await db.rawQuery('''
      SELECT
        COALESCE(SUM(CASE WHEN status = 'paid' THEN total_amount ELSE 0 END), 0) AS total_sales,
        COUNT(*) AS transaction_count
      FROM transactions
      WHERE date(created_at) = date('now', 'localtime', '-1 day')
    ''')).first;

    final hourlyRows = await db.rawQuery('''
      SELECT strftime('%H', created_at) AS hour, COALESCE(SUM(total_amount), 0) AS total
      FROM transactions
      WHERE date(created_at) = date('now', 'localtime') AND status = 'paid'
      GROUP BY hour
    ''');

    final hourlySales = <int, int>{
      for (final row in hourlyRows) int.parse(row['hour'] as String): row['total'] as int,
    };

    final recentRows = await db.rawQuery('''
      SELECT t.invoice_no, t.created_at, t.payment_method, t.total_amount,
        (SELECT COUNT(*) FROM transaction_items ti WHERE ti.transaction_id = t.id) AS item_count
      FROM transactions t
      WHERE t.status = 'paid'
      ORDER BY t.created_at DESC
      LIMIT 10
    ''');

    return DailyReport(
      totalSales: todayRow['total_sales'] as int,
      transactionCount: todayRow['transaction_count'] as int,
      yesterdaySales: yesterdayRow['total_sales'] as int,
      yesterdayTransactionCount: yesterdayRow['transaction_count'] as int,
      hourlySales: hourlySales,
      recentTransactions: recentRows
          .map((row) => RecentTransaction(
                invoiceNo: row['invoice_no'] as String,
                createdAt: DateTime.parse(row['created_at'] as String),
                itemCount: row['item_count'] as int,
                paymentMethod: row['payment_method'] as String,
                totalAmount: row['total_amount'] as int,
              ))
          .toList(),
    );
  }
}
