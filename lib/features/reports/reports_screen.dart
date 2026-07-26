import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/daily_report.dart';
import '../../data/repositories/report_repository.dart';
import '../../l10n/gen/app_localizations.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final _repository = ReportRepository();
  DailyReport? _report;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final report = await _repository.getDailyReport();
    if (mounted) setState(() => _report = report);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final paymentLabels = {
      'cash': l10n.commonPaidCash,
      'qris': l10n.commonPaidQris,
      'debit': l10n.commonPaidDebit,
    };
    final report = _report;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: report == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now()),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  _SalesCard(report: report),
                  const SizedBox(height: 16),
                  _TransactionCountCard(report: report),
                  const SizedBox(height: 20),
                  Text(l10n.reportsRecentTransactions, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (report.recentTransactions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(l10n.reportsNoTransactions, style: const TextStyle(color: AppColors.textSecondary)),
                      ),
                    )
                  else
                    ...report.recentTransactions.map(
                      (trx) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(trx.invoiceNo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(
                                    l10n.reportsTransactionSummary(
                                      DateFormat('HH:mm').format(trx.createdAt),
                                      trx.itemCount,
                                      paymentLabels[trx.paymentMethod] ?? trx.paymentMethod,
                                    ),
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(formatCurrency(trx.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _SalesCard extends StatelessWidget {
  const _SalesCard({required this.report});

  final DailyReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final percent = report.salesChangePercent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.reportsTotalSalesToday, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 6),
          Text(formatCurrency(report.totalSales), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          if (percent != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  percent >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: percent >= 0 ? AppColors.success : AppColors.danger,
                ),
                const SizedBox(width: 4),
                Text(
                  l10n.reportsChangeVsYesterday(percent.abs().toStringAsFixed(0)),
                  style: TextStyle(
                    color: percent >= 0 ? AppColors.success : AppColors.danger,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Text(l10n.reportsSalesPerHour, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          _HourlyChart(hourlySales: report.hourlySales),
        ],
      ),
    );
  }
}

class _HourlyChart extends StatelessWidget {
  const _HourlyChart({required this.hourlySales});

  final Map<int, int> hourlySales;

  @override
  Widget build(BuildContext context) {
    if (hourlySales.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text(AppLocalizations.of(context).reportsNoSalesToday, style: const TextStyle(color: AppColors.textSecondary))),
      );
    }

    final hours = hourlySales.keys.toList()..sort();
    final maxValue = hourlySales.values.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final hour in hours)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: maxValue == 0 ? 0 : (hourlySales[hour]! / maxValue) * 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primaryLight, AppColors.primary],
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(hour.toString().padLeft(2, '0'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TransactionCountCard extends StatelessWidget {
  const _TransactionCountCard({required this.report});

  final DailyReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final delta = report.transactionCountDelta;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(color: Color(0xFFFEF3C7), shape: BoxShape.circle),
            child: const Icon(Icons.tag, color: Color(0xFFB45309)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reportsTransactionCount, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                Text('${report.transactionCount}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          if (delta != 0)
            Text(
              l10n.reportsTransactionDelta('${delta > 0 ? '+' : ''}$delta'),
              style: TextStyle(
                color: delta > 0 ? AppColors.success : AppColors.danger,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
