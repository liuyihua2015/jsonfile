import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 创建示例表
        await db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, quantity INTEGER)',
        );
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT)',
        );
      },
    );
  }

  // 插入示例数据
  Future<void> insertItem(String name, int quantity) async {
    final db = await database;
    await db.insert(
      'items',
      {'name': name, 'quantity': quantity},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertUser(String username, String email) async {
    final db = await database;
    await db.insert(
      'users',
      {'username': username, 'email': email},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 获取所有表的名称
  Future<List<String>> getTableNames() async {
    final db = await database;
    // 查询 sqlite_master 表获取所有用户表
    final List<Map<String, dynamic>> tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'",
    );
    return tables.map((table) => table['name'] as String).toList();
  }

  // 获取指定表的数据
  Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }

  // 插入多条数据
  Future<void> insertMultipleData(
      String tableName, List<Map<String, dynamic>> data) async {
    final db = await database;
    Batch batch = db.batch();
    for (var row in data) {
      batch.insert(
        tableName,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  // 清空所有表的数据
  Future<void> clearDatabase() async {
    final db = await database;
    List<String> tableNames = await getTableNames();
    Batch batch = db.batch();
    for (String table in tableNames) {
      batch.delete(table);
    }
    await batch.commit(noResult: true);
  }
}
