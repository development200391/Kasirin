import 'dart:io';

import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../data/models/period_report.dart';
import 'formatters.dart';

String _periodFileLabel(PeriodReport report) {
  final formatter = DateFormat('yyyyMMdd');
  return '${formatter.format(report.startDate)}-${formatter.format(report.endDate)}';
}

Future<void> exportPeriodReportToExcel(PeriodReport report) async {
  final excel = Excel.createExcel();
  const sheetName = 'Laporan Periode';
  excel.rename(excel.getDefaultSheet()!, sheetName);
  final sheet = excel[sheetName];

  sheet.appendRow([TextCellValue('Laporan Periode Kasirin')]);
  sheet.appendRow([
    TextCellValue(report.type == ReportPeriodType.weekly ? 'Mingguan' : 'Bulanan'),
  ]);
  sheet.appendRow([
    TextCellValue('${DateFormat('d MMM yyyy').format(report.startDate)} - ${DateFormat('d MMM yyyy').format(report.endDate)}'),
  ]);
  sheet.appendRow([]);
  sheet.appendRow([TextCellValue('Total Penjualan'), IntCellValue(report.totalSales)]);
  sheet.appendRow([TextCellValue('Jumlah Transaksi'), IntCellValue(report.transactionCount)]);
  sheet.appendRow([]);
  sheet.appendRow([
    TextCellValue('Tanggal'),
    TextCellValue('Jumlah Transaksi'),
    TextCellValue('Total Penjualan'),
  ]);
  for (final day in report.dailySales) {
    sheet.appendRow([
      TextCellValue(DateFormat('EEEE, d MMM yyyy').format(day.date)),
      IntCellValue(day.transactionCount),
      IntCellValue(day.totalSales),
    ]);
  }

  final bytes = excel.encode();
  if (bytes == null) throw Exception('Gagal membuat file Excel');

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/laporan-periode-${_periodFileLabel(report)}.xlsx');
  await file.writeAsBytes(bytes, flush: true);

  await SharePlus.instance.share(
    ShareParams(files: [XFile(file.path)], text: 'Laporan Periode Kasirin'),
  );
}

Future<void> exportPeriodReportToPdf(PeriodReport report) async {
  final doc = pw.Document();
  final periodLabel = report.type == ReportPeriodType.weekly
      ? '${DateFormat('d MMM yyyy').format(report.startDate)} - ${DateFormat('d MMM yyyy').format(report.endDate)}'
      : DateFormat('MMMM yyyy').format(report.startDate);

  doc.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text('Laporan Periode Kasirin', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text(report.type == ReportPeriodType.weekly ? 'Mingguan · $periodLabel' : 'Bulanan · $periodLabel'),
        pw.SizedBox(height: 16),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Total Penjualan: ${formatCurrency(report.totalSales)}'),
            pw.Text('Jumlah Transaksi: ${report.transactionCount}'),
          ],
        ),
        pw.SizedBox(height: 16),
        pw.TableHelper.fromTextArray(
          headers: ['Hari / Tanggal', 'Transaksi', 'Penjualan'],
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
    ShareParams(files: [XFile(file.path)], text: 'Laporan Periode Kasirin'),
  );
}
