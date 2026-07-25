import '../db/database_helper.dart';
import '../models/cart_item.dart';
import '../models/transaction_result.dart';

class TransactionRepository {
  Future<TransactionResult> checkout({
    required List<CartItem> items,
    required int discount,
    required int paidAmount,
    required int userId,
  }) async {
    final db = await DatabaseHelper.instance.database;

    final subtotal = items.fold<int>(0, (sum, item) => sum + item.subtotal);
    final total = (subtotal - discount) < 0 ? 0 : subtotal - discount;
    final change = paidAmount - total;
    final now = DateTime.now();

    final countRow = await db.rawQuery('SELECT COUNT(*) AS c FROM transactions');
    final invoiceNo = 'TRX-${((countRow.first['c'] as int) + 1).toString().padLeft(4, '0')}';

    late int transactionId;

    await db.transaction((txn) async {
      transactionId = await txn.insert('transactions', {
        'user_id': userId,
        'invoice_no': invoiceNo,
        'total_amount': total,
        'discount': discount,
        'tax': 0,
        'paid_amount': paidAmount,
        'change_amount': change,
        'payment_method': 'cash',
        'status': 'paid',
        'created_at': now.toIso8601String(),
      });

      for (final item in items) {
        await txn.insert('transaction_items', {
          'transaction_id': transactionId,
          'product_id': item.product.id,
          'qty': item.qty,
          'price': item.product.price,
          'subtotal': item.subtotal,
        });

        await txn.update(
          'products',
          {'stock_qty': item.product.stockQty - item.qty},
          where: 'id = ?',
          whereArgs: [item.product.id],
        );

        await txn.insert('stock_movements', {
          'product_id': item.product.id,
          'type': 'out',
          'qty': item.qty,
          'note': 'Transaksi $invoiceNo',
          'created_at': now.toIso8601String(),
        });
      }
    });

    return TransactionResult(
      id: transactionId,
      invoiceNo: invoiceNo,
      items: items
          .map((item) => TransactionItemResult(
                productName: item.product.name,
                qty: item.qty,
                price: item.product.price,
                subtotal: item.subtotal,
              ))
          .toList(),
      subtotal: subtotal,
      discount: discount,
      totalAmount: total,
      paidAmount: paidAmount,
      changeAmount: change,
      createdAt: now,
    );
  }
}
