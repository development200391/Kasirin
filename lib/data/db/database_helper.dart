import 'package:sqflite/sqflite.dart';

import 'seed.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const _dbName = 'kasirin.db';
  static const _dbVersion = 2;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      '$path/$_dbName',
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN is_active INTEGER NOT NULL DEFAULT 1');
      await db.execute('ALTER TABLE users ADD COLUMN permissions TEXT');
      await db.update('users', {'permissions': 'pos.transaction,products.view,products.manage,users.manage,reports.view'}, where: "role = 'admin'");
      await db.update('users', {'permissions': 'pos.transaction,products.view'}, where: "role != 'admin'");
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        username TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        role TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        permissions TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER REFERENCES categories(id),
        sku TEXT,
        name TEXT NOT NULL,
        price INTEGER NOT NULL,
        cost_price INTEGER NOT NULL DEFAULT 0,
        stock_qty INTEGER NOT NULL DEFAULT 0,
        unit TEXT,
        image_path TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE stock_movements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL REFERENCES products(id),
        type TEXT NOT NULL,
        qty INTEGER NOT NULL,
        note TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL REFERENCES users(id),
        invoice_no TEXT NOT NULL,
        total_amount INTEGER NOT NULL,
        discount INTEGER NOT NULL DEFAULT 0,
        tax INTEGER NOT NULL DEFAULT 0,
        paid_amount INTEGER NOT NULL,
        change_amount INTEGER NOT NULL,
        payment_method TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE transaction_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_id INTEGER NOT NULL REFERENCES transactions(id),
        product_id INTEGER NOT NULL REFERENCES products(id),
        qty INTEGER NOT NULL,
        price INTEGER NOT NULL,
        subtotal INTEGER NOT NULL
      )
    ''');

    await seedDefaultAdmin(db);
  }
}
