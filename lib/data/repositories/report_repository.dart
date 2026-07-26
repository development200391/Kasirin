import '../db/database_helper.dart';
import '../models/daily_report.dart';
import '../models/period_report.dart';

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

  Future<PeriodReport> getPeriodReport({
    required ReportPeriodType type,
    required DateTime anchor,
  }) async {
    final db = await DatabaseHelper.instance.database;

    final (start, end) = periodBoundsFor(type, anchor);
    final (prevStart, prevEnd) = previousPeriodBoundsFor(type, start);

    final dailyRows = await db.rawQuery(
      '''
      SELECT date(created_at) AS day, COUNT(*) AS cnt, COALESCE(SUM(total_amount), 0) AS total
      FROM transactions
      WHERE status = 'paid' AND date(created_at) BETWEEN date(?) AND date(?)
      GROUP BY day
      ''',
      [_isoDate(start), _isoDate(end)],
    );

    final dailyMap = <String, ({int count, int total})>{
      for (final row in dailyRows) row['day'] as String: (count: row['cnt'] as int, total: row['total'] as int),
    };

    final dailySales = <DailySales>[];
    for (var day = start; !day.isAfter(end); day = day.add(const Duration(days: 1))) {
      final entry = dailyMap[_isoDate(day)];
      dailySales.add(DailySales(date: day, transactionCount: entry?.count ?? 0, totalSales: entry?.total ?? 0));
    }

    final totalSales = dailySales.fold<int>(0, (sum, d) => sum + d.totalSales);
    final transactionCount = dailySales.fold<int>(0, (sum, d) => sum + d.transactionCount);

    final prevRow = (await db.rawQuery(
      '''
      SELECT COALESCE(SUM(total_amount), 0) AS total
      FROM transactions
      WHERE status = 'paid' AND date(created_at) BETWEEN date(?) AND date(?)
      ''',
      [_isoDate(prevStart), _isoDate(prevEnd)],
    )).first;

    return PeriodReport(
      type: type,
      startDate: start,
      endDate: end,
      totalSales: totalSales,
      transactionCount: transactionCount,
      previousTotalSales: prevRow['total'] as int,
      dailySales: dailySales,
    );
  }

  String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Returns (start, end) date-only bounds of the period containing [anchor].
/// Weekly periods run Monday-Sunday; monthly periods run the full calendar month.
(DateTime, DateTime) periodBoundsFor(ReportPeriodType type, DateTime anchor) {
  final day = DateTime(anchor.year, anchor.month, anchor.day);
  if (type == ReportPeriodType.weekly) {
    final start = day.subtract(Duration(days: day.weekday - 1));
    return (start, start.add(const Duration(days: 6)));
  }
  final start = DateTime(day.year, day.month, 1);
  final end = DateTime(day.year, day.month + 1, 1).subtract(const Duration(days: 1));
  return (start, end);
}

/// Returns (start, end) bounds of the period immediately before the one starting at [periodStart].
(DateTime, DateTime) previousPeriodBoundsFor(ReportPeriodType type, DateTime periodStart) {
  final prevEnd = periodStart.subtract(const Duration(days: 1));
  if (type == ReportPeriodType.weekly) {
    return (prevEnd.subtract(const Duration(days: 6)), prevEnd);
  }
  return (DateTime(prevEnd.year, prevEnd.month, 1), prevEnd);
}
