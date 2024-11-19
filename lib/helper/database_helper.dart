import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static DatabaseHelper databaseHelper = DatabaseHelper._();

  Database? _database;
  String databaseName = 'shopping.db';
  String tableName = 'shopping';

  Future<Database> get database async => _database ?? await initDatabase();

  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, databaseName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        String sql = '''
        CREATE TABLE $tableName (
          name TEXT NOT NULL, 
          qut INTEGER NOT NULL, 
          cate TEXT NOT NULL,
          done NOT NULL DEFAULT 0,
        )
        ''';
        db.execute(sql);
      },
    );
  }

  Future<bool> expenseExist(int id) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE id = ?
    ''';
    List<Map<String, Object?>> result = await db.rawQuery(sql, [id]);
    return result.isNotEmpty;
  }

  Future<int> addExpenseToDatabase(
    String name,
    int qut,
    String cate,
    bool done,
  ) async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName (name, qut, cate, done) VALUES (?, ?, ?, ?)
    ''';
    List args = [name, qut, cate, done ? 1 : 0];
    return await db.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> readAllExpense() async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName
    ''';
    return await db.rawQuery(sql);
  }

  Future<List<Map<String, Object?>>> getExpenseByCategory(
      String category) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE cate LIKE '%$category%'
    ''';
    return await db.rawQuery(sql);
  }

  Future<int> updateExpense(
      String name, int qut, String cate, bool done) async {
    final db = await database;
    String sql = '''
    UPDATE $tableName SET name = ?, qut = ?, cate = ?, done = ?
    ''';
    List args = [name, qut, cate, done ? 1 : 0];
    return await db.rawUpdate(sql, args);
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    String sql = '''
    DELETE FROM $tableName WHERE id = ?
    ''';
    List args = [id];
    return await db.rawDelete(sql, args);
  }
}
