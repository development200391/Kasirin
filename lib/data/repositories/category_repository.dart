import '../db/database_helper.dart';
import '../models/category.dart';

class CategoryRepository {
  Future<List<ProductCategory>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('categories', orderBy: 'name ASC');
    return rows.map(ProductCategory.fromMap).toList();
  }

  Future<int> add(String name) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert('categories', {'name': name});
  }

  Future<void> update(int id, String name) async {
    final db = await DatabaseHelper.instance.database;
    await db.update('categories', {'name': name}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
