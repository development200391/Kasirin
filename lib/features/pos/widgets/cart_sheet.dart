import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../cart_provider.dart';
import 'payment_sheet.dart';

class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  Future<void> _editDiscount(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: cart.discount == 0 ? '' : cart.discount.toString());

    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.commonDiscount),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.cartDiscountLabel, prefixText: 'Rp '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.commonCancel)),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: Text(l10n.commonSave)),
        ],
      ),
    );

    if (value != null) {
      cart.setDiscount(int.tryParse(value) ?? 0);
    }
  }

  Future<void> _confirmClear(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cartCancelTransaction),
        content: Text(l10n.cartConfirmClear),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.commonNo)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.cartConfirmCancel),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<CartProvider>().clear();
      Navigator.of(context).pop();
    }
  }

  void _openPayment(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<CartProvider>(),
        child: const PaymentSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final l10n = AppLocalizations.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Text(l10n.cartCurrentOrder, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(l10n.cartItemCount(cart.itemCount), style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: cart.isEmpty
                    ? Center(child: Text(l10n.cartEmpty, style: const TextStyle(color: AppColors.textSecondary)))
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        itemCount: cart.items.length,
                        separatorBuilder: (_, _) => const Divider(height: 24),
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(
                                      '${item.qty} x ${formatCurrency(item.product.price)}',
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              _QtyStepper(
                                qty: item.qty,
                                onDecrement: () => cart.decrementQty(item.product),
                                onIncrement: () {
                                  if (!cart.addProduct(item.product)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(l10n.posOutOfStock)),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 84,
                                child: Text(
                                  formatCurrency(item.subtotal),
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.commonSubtotal, style: const TextStyle(color: AppColors.textSecondary)),
                        Text(formatCurrency(cart.subtotal)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.commonDiscount, style: const TextStyle(color: AppColors.textSecondary)),
                        Text('-${formatCurrency(cart.discount)}', style: const TextStyle(color: AppColors.danger)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.commonTotal, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          formatCurrency(cart.total),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: cart.isEmpty ? null : () => _editDiscount(context),
                            child: Text(l10n.commonDiscount),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: AppColors.danger),
                            ),
                            onPressed: cart.isEmpty ? null : () => _confirmClear(context),
                            child: Text(l10n.cartCancelButton),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: cart.isEmpty ? null : () => _openPayment(context),
                      child: Text(l10n.cartPay(formatCurrency(cart.total))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({required this.qty, required this.onDecrement, required this.onIncrement});

  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepperButton(icon: Icons.remove, onTap: onDecrement),
        SizedBox(width: 28, child: Text('$qty', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))),
        _StepperButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(color: AppColors.background, shape: BoxShape.circle),
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }
}
