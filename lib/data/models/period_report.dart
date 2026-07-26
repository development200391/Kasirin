enum ReportPeriodType { weekly, monthly }

class DailySales {
  const DailySales({
    required this.date,
    required this.transactionCount,
    required this.totalSales,
  });

  final DateTime date;
  final int transactionCount;
  final int totalSales;
}

class PeriodReport {
  const PeriodReport({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.totalSales,
    required this.transactionCount,
    required this.previousTotalSales,
    required this.dailySales,
  });

  final ReportPeriodType type;
  final DateTime startDate;
  final DateTime endDate;
  final int totalSales;
  final int transactionCount;
  final int previousTotalSales;
  final List<DailySales> dailySales;

  double? get salesChangePercent {
    if (previousTotalSales == 0) return null;
    return ((totalSales - previousTotalSales) / previousTotalSales) * 100;
  }

  DailySales? get bestDay {
    if (dailySales.isEmpty) return null;
    return dailySales.reduce((a, b) => b.totalSales > a.totalSales ? b : a);
  }
}
