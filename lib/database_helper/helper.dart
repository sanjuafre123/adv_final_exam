import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static DatabaseHelper databaseHelper = DatabaseHelper._();

  Database? _database;
  String databaseName = 'attendence.db';
  String tableName = 'attendence';

  Future<Database> get database async => _database ?? await initDatabase();

  Future<Future<Database>> initDatabase() async {
    final path = await getDatabasesPath();
    final dbpath = join(path, databaseName);

    return openDatabase(
      dbpath,
      version: 1,
      onCreate: (db, version) {
        String sql = '''
        CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        date TEXT NOT null,
        present TEXT NOT null,
        )
        ''';
        db.execute(sql);
      },
    );
  }

  Future<bool> TrackerExists(int id) async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName WHERE id = ?
    ''';
    List<Map<String, Object?>> result = await db.rawQuery(sql, [id]);
    return result.isNotEmpty;
  }

  Future<int> addDataBase(String name, String date, String present) async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName(
    name,data,present
    ) VALUES (? , ? , ?)
    ''';
    List args = [name, context, date, present];
    return await db.rawInsert(sql, args);
  }

  Future<List<Map<String, Object?>>> readData() async {
    final db = await database;
    String sql = '''
    SELECT*FROM $tableName
    ''';
    return await db.rawQuery(sql);
  }

  Future<int> updateAttendence(int id ,String name, String date, String present) async {
    final db = await database;
    String sql = '''
    UPDATE $tableName SET name = ?, date = ?, present = ? WHERE id = ?
    ''';
    List args = [name, context, date, present,id];
    return await db.rawUpdate(sql, args);
  }

  Future<int> deleteAttendence(int id ) async {
    final db = await database;
    String sql = '''
    DELETE FROm $tableName WHERE id = ?
    ''';
    List args = [id];
    return await db.rawDelete(sql, args);
  }
}
