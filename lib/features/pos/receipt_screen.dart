import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/transaction_result.dart';
import '../printer/printer_provider.dart';
import '../printer/printer_screen.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key, required this.result});

  final TransactionResult result;

  Future<void> _printReceipt(BuildContext context) async {
    final printer = context.read<PrinterProvider>();
    await printer.refreshStatus();

    if (!printer.isConnected) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Printer belum terhubung'),
          action: SnackBarAction(
            label: 'Hubungkan',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PrinterScreen()),
            ),
          ),
        ),
      );
      return;
    }

    final success = await printer.printReceipt(result);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? 'Struk berhasil dicetak' : 'Gagal mencetak struk')),
    );
  }

  void _showDigitalReceipt(BuildContext context) {
    final buffer = StringBuffer()
      ..writeln('KASIRIN')
      ..writeln(result.invoiceNo)
      ..writeln(DateFormat('dd MMM yyyy, HH:mm').format(result.createdAt))
      ..writeln('--------------------------------');

    for (final item in result.items) {
      final qtyPrice = '${item.qty} x ${formatCurrency(item.price)}'.padRight(22);
      buffer
        ..writeln(item.productName)
        ..writeln('$qtyPrice${formatCurrency(item.subtotal)}');
    }

    buffer
      ..writeln('--------------------------------')
      ..writeln('${'Subtotal'.padRight(18)}${formatCurrency(result.subtotal)}')
      ..writeln('${'Diskon'.padRight(18)}-${formatCurrency(result.discount)}')
      ..writeln('${'Total'.padRight(18)}${formatCurrency(result.totalAmount)}')
      ..writeln('${'Uang Bayar'.padRight(18)}${formatCurrency(result.paidAmount)}')
      ..writeln('${'Kembalian'.padRight(18)}${formatCurrency(result.changeAmount)}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Struk Digital'),
        content: SingleChildScrollView(
          child: Text(buffer.toString(), style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tutup')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: AppColors.success, size: 36),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pembayaran Berhasil!',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${result.invoiceNo} · ${DateFormat('dd MMM yyyy, HH:mm').format(result.createdAt)}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'KEMBALIAN',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatCurrency(result.changeAmount),
                            style: const TextStyle(color: Color(0xFF4338CA), fontWeight: FontWeight.bold, fontSize: 26),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    for (final item in result.items)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(
                                    '${item.qty} x ${formatCurrency(item.price)}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Text(formatCurrency(item.subtotal), style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    const Divider(),
                    const SizedBox(height: 4),
                    _SummaryRow(label: 'Subtotal', value: formatCurrency(result.subtotal)),
                    _SummaryRow(label: 'Diskon', value: '-${formatCurrency(result.discount)}'),
                    _SummaryRow(
                      label: 'Total',
                      value: formatCurrency(result.totalAmount),
                      bold: true,
                    ),
                    _SummaryRow(label: 'Uang Bayar', value: formatCurrency(result.paidAmount)),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _printReceipt(context),
                        child: const Text('Cetak Struk'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _showDigitalReceipt(context),
                        child: const Text('Tampilkan Struk Digital'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                      child: const Text('Transaksi Baru'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: bold ? AppColors.primary : AppColors.textSecondary,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 16 : 14,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: bold ? style.copyWith(color: AppColors.primary) : const TextStyle(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
