import '../db/database_helper.dart';
import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> search({int? categoryId, String query = ''}) async {
    final db = await DatabaseHelper.instance.database;

    final where = <String>[];
    final args = <Object?>[];

    if (categoryId != null) {
      where.add('p.category_id = ?');
      args.add(categoryId);
    }
    if (query.trim().isNotEmpty) {
      where.add('(p.name LIKE ? OR p.sku LIKE ?)');
      args.add('%${query.trim()}%');
      args.add('%${query.trim()}%');
    }

    final whereClause = where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}';

    final rows = await db.rawQuery('''
      SELECT p.*, c.name AS category_name
      FROM products p
      LEFT JOIN categories c ON c.id = p.category_id
      $whereClause
      ORDER BY p.name ASC
    ''', args);

    return rows.map(Product.fromMap).toList();
  }

  Future<int> add(Product product) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert('products', {
      'category_id': product.categoryId,
      'sku': product.sku,
      'name': product.name,
      'price': product.price,
      'cost_price': product.costPrice,
      'stock_qty': product.stockQty,
      'unit': product.unit,
      'image_path': product.imagePath,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> update(Product product) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'products',
      {
        'category_id': product.categoryId,
        'sku': product.sku,
        'name': product.name,
        'price': product.price,
        'cost_price': product.costPrice,
        'stock_qty': product.stockQty,
        'unit': product.unit,
        'image_path': product.imagePath,
      },
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
