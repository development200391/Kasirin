import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/report_exporter.dart';
import '../../data/models/period_report.dart';
import 'period_report_provider.dart';

class PeriodReportScreen extends StatelessWidget {
  const PeriodReportScreen({super.key});

  Future<void> _export(BuildContext context, Future<void> Function(PeriodReport) exportFn) async {
    final report = context.read<PeriodReportProvider>().report;
    if (report == null) return;

    try {
      await exportFn(report);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat file laporan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PeriodReportProvider>();
    final report = provider.report;

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Periode')),
      body: provider.isLoading && report == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SegmentedButton<ReportPeriodType>(
                    segments: const [
                      ButtonSegment(value: ReportPeriodType.weekly, label: Text('Mingguan')),
                      ButtonSegment(value: ReportPeriodType.monthly, label: Text('Bulanan')),
                    ],
                    selected: {provider.type},
                    onSelectionChanged: (selection) => provider.setType(selection.first),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        onPressed: provider.goToPrevious,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Expanded(
                        child: Text(
                          report == null ? '' : _periodLabel(report),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      IconButton(
                        onPressed: provider.canGoNext ? provider.goToNext : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  if (report != null) ...[
                    const SizedBox(height: 8),
                    _SummaryCard(report: report),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _export(context, exportPeriodReportToExcel),
                            icon: const Icon(Icons.table_chart_outlined),
                            label: const Text('Export ke Excel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _export(context, exportPeriodReportToPdf),
                            icon: const Icon(Icons.picture_as_pdf_outlined),
                            label: const Text('Export ke PDF'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Rincian per Hari', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    _DailyTable(dailySales: report.dailySales),
                  ],
                ],
              ),
            ),
    );
  }

  String _periodLabel(PeriodReport report) {
    final formatter = DateFormat('d MMM yyyy', 'id_ID');
    if (report.type == ReportPeriodType.monthly) {
      return DateFormat('MMMM yyyy', 'id_ID').format(report.startDate);
    }
    return '${formatter.format(report.startDate)} - ${formatter.format(report.endDate)}';
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.report});

  final PeriodReport report;

  @override
  Widget build(BuildContext context) {
    final percent = report.salesChangePercent;
    final bestDay = report.bestDay;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryLight, Color(0xFF4338CA)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('TOTAL PENJUALAN', style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            formatCurrency(report.totalSales),
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          if (percent != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  percent >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: const Color(0xFFBBF7D0),
                ),
                const SizedBox(width: 4),
                Text(
                  '${percent.abs().toStringAsFixed(0)}% dari periode lalu',
                  style: const TextStyle(color: Color(0xFFBBF7D0), fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          const Text('JUMLAH TRANSAKSI', style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('${report.transactionCount}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          const Text('HARI TERBAIK', style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(
            bestDay == null || bestDay.totalSales == 0
                ? '-'
                : '${DateFormat('EEEE, d MMM', 'id_ID').format(bestDay.date)} · ${formatCurrency(bestDay.totalSales)}',
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DailyTable extends StatelessWidget {
  const _DailyTable({required this.dailySales});

  final List<DailySales> dailySales;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('HARI / TANGGAL', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('TRANSAKSI', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(
                  flex: 3,
                  child: Text(
                    'PENJUALAN',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < dailySales.length; i++)
            Container(
              color: i.isOdd ? const Color(0xFFFAFAFB) : AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      DateFormat('EEEE, d MMM', 'id_ID').format(dailySales[i].date),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('${dailySales[i].transactionCount} trx', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      formatCurrency(dailySales[i].totalSales),
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
