class RecentTransaction {
  const RecentTransaction({
    required this.invoiceNo,
    required this.createdAt,
    required this.itemCount,
    required this.paymentMethod,
    required this.totalAmount,
  });

  final String invoiceNo;
  final DateTime createdAt;
  final int itemCount;
  final String paymentMethod;
  final int totalAmount;
}

class DailyReport {
  const DailyReport({
    required this.totalSales,
    required this.transactionCount,
    required this.yesterdaySales,
    required this.yesterdayTransactionCount,
    required this.hourlySales,
    required this.recentTransactions,
  });

  final int totalSales;
  final int transactionCount;
  final int yesterdaySales;
  final int yesterdayTransactionCount;
  final Map<int, int> hourlySales;
  final List<RecentTransaction> recentTransactions;

  double? get salesChangePercent {
    if (yesterdaySales == 0) return null;
    return ((totalSales - yesterdaySales) / yesterdaySales) * 100;
  }

  int get transactionCountDelta => transactionCount - yesterdayTransactionCount;
}
