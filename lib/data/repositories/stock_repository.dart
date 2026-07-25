import '../db/database_helper.dart';
import '../models/stock_movement.dart';

class StockRepository {
  Future<List<StockMovement>> getMovements(int productId) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'stock_movements',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'created_at DESC',
    );
    return rows.map(StockMovement.fromMap).toList();
  }

  /// [type] is 'in' to add stock or 'adjustment' to reduce stock manually.
  Future<void> addMovement({
    required int productId,
    required int currentStock,
    required String type,
    required int qty,
    String? note,
  }) async {
    final db = await DatabaseHelper.instance.database;
    final now = DateTime.now().toIso8601String();
    final delta = type == 'in' ? qty : -qty;
    final newStock = currentStock + delta;

    await db.transaction((txn) async {
      await txn.insert('stock_movements', {
        'product_id': productId,
        'type': type,
        'qty': qty,
        'note': note,
        'created_at': now,
      });

      await txn.update(
        'products',
        {'stock_qty': newStock < 0 ? 0 : newStock},
        where: 'id = ?',
        whereArgs: [productId],
      );
    });
  }
}
