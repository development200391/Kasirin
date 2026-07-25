import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/product.dart';
import '../../data/models/stock_movement.dart';
import '../../data/repositories/stock_repository.dart';
import '../products/products_provider.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  final _repository = StockRepository();
  List<StockMovement>? _movements;
  int _currentStock = 0;

  @override
  void initState() {
    super.initState();
    _currentStock = widget.product.stockQty;
    _loadMovements();
  }

  Future<void> _loadMovements() async {
    final movements = await _repository.getMovements(widget.product.id!);
    if (mounted) setState(() => _movements = movements);
  }

  Future<void> _showMovementDialog({required String type}) async {
    final controller = TextEditingController();
    final noteController = TextEditingController();
    final isAdd = type == 'in';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAdd ? 'Tambah Stok' : 'Kurangi Stok'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Catatan (opsional)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Simpan')),
        ],
      ),
    );

    final qty = int.tryParse(controller.text) ?? 0;
    if (confirmed != true || qty <= 0 || !mounted) return;

    await _repository.addMovement(
      productId: widget.product.id!,
      currentStock: _currentStock,
      type: isAdd ? 'in' : 'adjustment',
      qty: qty,
      note: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
    );

    setState(() => _currentStock = (isAdd ? _currentStock + qty : _currentStock - qty).clamp(0, 1 << 62));
    if (mounted) {
      await context.read<ProductsProvider>().load();
      _loadMovements();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLowStock = _currentStock < 10;

    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const Text('Stok Saat Ini', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Text(
                  '$_currentStock ${widget.product.unit ?? 'pcs'}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isLowStock ? AppColors.danger : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showMovementDialog(type: 'in'),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Stok'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.danger,
                          side: const BorderSide(color: AppColors.danger),
                        ),
                        onPressed: () => _showMovementDialog(type: 'adjustment'),
                        icon: const Icon(Icons.remove),
                        label: const Text('Kurangi Stok'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                Text('Riwayat Pergerakan Stok', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _movements == null
                ? const Center(child: CircularProgressIndicator())
                : _movements!.isEmpty
                    ? const Center(child: Text('Belum ada pergerakan stok', style: TextStyle(color: AppColors.textSecondary)))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: _movements!.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) => _MovementTile(movement: _movements![index]),
                      ),
          ),
        ],
      ),
    );
  }
}

class _MovementTile extends StatelessWidget {
  const _MovementTile({required this.movement});

  final StockMovement movement;

  @override
  Widget build(BuildContext context) {
    final isIn = movement.type == 'in';
    final label = switch (movement.type) {
      'in' => 'Masuk',
      'out' => 'Keluar (Transaksi)',
      _ => 'Penyesuaian',
    };
    final color = isIn ? AppColors.success : AppColors.danger;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(isIn ? Icons.arrow_downward : Icons.arrow_upward, color: color, size: 18),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        movement.note == null
            ? DateFormat('dd MMM yyyy, HH:mm').format(movement.createdAt)
            : '${DateFormat('dd MMM yyyy, HH:mm').format(movement.createdAt)} · ${movement.note}',
      ),
      trailing: Text(
        '${isIn ? '+' : '-'}${movement.qty}',
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
