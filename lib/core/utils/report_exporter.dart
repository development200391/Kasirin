import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../data/models/period_report.dart';
import '../../l10n/gen/app_localizations.dart';
import 'formatters.dart';

String _periodFileLabel(PeriodReport report) {
  final formatter = DateFormat('yyyyMMdd');
  return '${formatter.format(report.startDate)}-${formatter.format(report.endDate)}';
}

Future<void> exportPeriodReportToExcel(PeriodReport report, AppLocalizations l10n) async {
  final excel = Excel.createExcel();
  final sheetName = l10n.periodReportHeading;
  excel.rename(excel.getDefaultSheet()!, sheetName);
  final sheet = excel[sheetName];

  sheet.appendRow([TextCellValue(l10n.periodReportHeading)]);
  sheet.appendRow([
    TextCellValue(report.type == ReportPeriodType.weekly ? l10n.periodWeekly : l10n.periodMonthly),
  ]);
  sheet.appendRow([
    TextCellValue('${DateFormat('d MMM yyyy').format(report.startDate)} - ${DateFormat('d MMM yyyy').format(report.endDate)}'),
  ]);
  sheet.appendRow([]);
  sheet.appendRow([TextCellValue(l10n.periodTotalSales), IntCellValue(report.totalSales)]);
  sheet.appendRow([TextCellValue(l10n.reportsTransactionCount), IntCellValue(report.transactionCount)]);
  sheet.appendRow([]);
  sheet.appendRow([
    TextCellValue(l10n.periodColDate),
    TextCellValue(l10n.reportsTransactionCount),
    TextCellValue(l10n.periodTotalSales),
  ]);
  for (final day in report.dailySales) {
    sheet.appendRow([
      TextCellValue(DateFormat('EEEE, d MMM yyyy').format(day.date)),
      IntCellValue(day.transactionCount),
      IntCellValue(day.totalSales),
    ]);
  }

  final bytes = excel.encode();
  if (bytes == null) throw Exception('Failed to build Excel file');

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/laporan-periode-${_periodFileLabel(report)}.xlsx');
  await file.writeAsBytes(bytes, flush: true);

  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path)], text: l10n.periodReportHeading),
  );
}

Future<void> exportPeriodReportToPdf(PeriodReport report, AppLocalizations l10n) async {
  final doc = pw.Document();
  final periodLabel = report.type == ReportPeriodType.weekly
      ? '${DateFormat('d MMM yyyy').format(report.startDate)} - ${DateFormat('d MMM yyyy').format(report.endDate)}'
      : DateFormat('MMMM yyyy').format(report.startDate);
  final periodType = report.type == ReportPeriodType.weekly ? l10n.periodWeekly : l10n.periodMonthly;

  doc.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text(l10n.periodReportHeading, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text('$periodType · $periodLabel'),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('${l10n.periodTotalSales}: ${formatCurrency(report.totalSales)}'),
            pw.Text('${l10n.reportsTransactionCount}: ${report.transactionCount}'),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.TableHelper.fromTextArray(
          headers: [l10n.periodColDate, l10n.periodColTransactions, l10n.periodColSales],
          data: [
            for (final day in report.dailySales)
              [
                DateFormat('EEEE, d MMM yyyy').format(day.date),
                '${day.transactionCount}',
                formatCurrency(day.totalSales),
              ],
          ],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
          headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF4F46E5)),
          cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.center, 2: pw.Alignment.centerRight},
        ),
      ],
    ),
  );

  final bytes = await doc.save();
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/laporan-periode-${_periodFileLabel(report)}.pdf');
  await file.writeAsBytes(bytes, flush: true);

  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path)], text: l10n.periodReportHeading),
  );
}
