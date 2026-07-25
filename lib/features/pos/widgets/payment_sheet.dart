import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../auth/auth_provider.dart';
import '../cart_provider.dart';
import '../receipt_screen.dart';

class PaymentSheet extends StatefulWidget {
  const PaymentSheet({super.key});

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  final _paidController = TextEditingController();
  final _repository = TransactionRepository();
  bool _isProcessing = false;

  int get _paidAmount => int.tryParse(_paidController.text) ?? 0;

  @override
  void dispose() {
    _paidController.dispose();
    super.dispose();
  }

  Future<void> _confirmPayment(int total) async {
    final cart = context.read<CartProvider>();
    final userId = context.read<AuthProvider>().currentUser!.id;

    setState(() => _isProcessing = true);

    final result = await _repository.checkout(
      items: cart.items,
      discount: cart.discount,
      paidAmount: _paidAmount,
      userId: userId,
    );

    cart.clear();

    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => ReceiptScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = context.watch<CartProvider>().total;
    final change = _paidAmount - total;
    final canConfirm = _paidAmount >= total && !_isProcessing;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Pembayaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Belanja', style: TextStyle(color: AppColors.textSecondary)),
              Text(formatCurrency(total), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _paidController,
            keyboardType: TextInputType.number,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Uang Bayar', prefixText: 'Rp '),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kembalian', style: TextStyle(color: AppColors.textSecondary)),
              Text(
                formatCurrency(change < 0 ? 0 : change),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: change < 0 ? AppColors.danger : AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: canConfirm ? () => _confirmPayment(total) : null,
            child: _isProcessing
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)),
                  )
                : const Text('Konfirmasi Bayar'),
          ),
        ],
      ),
    );
  }
}
