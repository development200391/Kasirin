import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/post_code.dart';

import '../../data/models/transaction_result.dart';
import 'formatters.dart';

/// 58mm printers fit ~32 monospace characters per line, 80mm fit ~48.
int charsPerLineFor(int paperWidthMm) => paperWidthMm <= 58 ? 32 : 48;

String _twoColumns(String left, String right, int width) {
  final maxLeft = width - right.length - 1;
  final trimmedLeft = left.length > maxLeft ? left.substring(0, maxLeft < 0 ? 0 : maxLeft) : left;
  final spaces = width - trimmedLeft.length - right.length;
  return '$trimmedLeft${' ' * (spaces < 1 ? 1 : spaces)}$right';
}

List<int> buildReceiptBytes(TransactionResult result, {required int paperWidthMm}) {
  final width = charsPerLineFor(paperWidthMm);
  final bytes = <int>[];

  bytes.addAll(PostCode.reset());
  bytes.addAll(PostCode.text(text: 'KASIRIN', align: AlignPos.center, bold: true, fontSize: FontSize.doubleHeight));
  bytes.addAll(PostCode.text(text: result.invoiceNo, align: AlignPos.center));
  bytes.addAll(PostCode.text(text: DateFormat('dd MMM yyyy, HH:mm').format(result.createdAt), align: AlignPos.center));
  bytes.addAll(PostCode.text(text: '-' * width, align: AlignPos.left));

  for (final item in result.items) {
    bytes.addAll(PostCode.text(text: item.productName, align: AlignPos.left));
    final qtyPrice = '${item.qty} x ${formatCurrency(item.price)}';
    bytes.addAll(PostCode.text(text: _twoColumns(qtyPrice, formatCurrency(item.subtotal), width), align: AlignPos.left));
  }

  bytes.addAll(PostCode.text(text: '-' * width, align: AlignPos.left));
  bytes.addAll(PostCode.text(text: _twoColumns('Subtotal', formatCurrency(result.subtotal), width), align: AlignPos.left));
  bytes.addAll(PostCode.text(text: _twoColumns('Diskon', '-${formatCurrency(result.discount)}', width), align: AlignPos.left));
  bytes.addAll(PostCode.text(text: _twoColumns('TOTAL', formatCurrency(result.totalAmount), width), align: AlignPos.left, bold: true));
  bytes.addAll(PostCode.text(text: _twoColumns('Uang Bayar', formatCurrency(result.paidAmount), width), align: AlignPos.left));
  bytes.addAll(PostCode.text(text: _twoColumns('Kembalian', formatCurrency(result.changeAmount), width), align: AlignPos.left));
  bytes.addAll(PostCode.text(text: '-' * width, align: AlignPos.left));
  bytes.addAll(PostCode.text(text: 'Terima kasih', align: AlignPos.center));
  bytes.addAll(PostCode.cut());

  return bytes;
}

List<int> buildTestPrintBytes({required int paperWidthMm, required String printerName}) {
  final width = charsPerLineFor(paperWidthMm);
  final bytes = <int>[];

  bytes.addAll(PostCode.reset());
  bytes.addAll(PostCode.text(text: 'KASIRIN', align: AlignPos.center, bold: true, fontSize: FontSize.doubleHeight));
  bytes.addAll(PostCode.text(text: 'Test Print Berhasil', align: AlignPos.center, bold: true));
  bytes.addAll(PostCode.text(text: '-' * width, align: AlignPos.left));
  bytes.addAll(PostCode.text(text: 'Printer: $printerName', align: AlignPos.left));
  bytes.addAll(PostCode.text(text: 'Kertas: ${paperWidthMm}mm', align: AlignPos.left));
  bytes.addAll(PostCode.text(text: DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()), align: AlignPos.left));
  bytes.addAll(PostCode.text(text: '-' * width, align: AlignPos.left));
  bytes.addAll(PostCode.cut());

  return bytes;
}
