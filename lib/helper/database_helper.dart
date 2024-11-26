import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseService {
  DataBaseService._();

  static DataBaseService dataBaseService = DataBaseService._();

  Database? _db;
  String tableName = "habitTracker";

  Future get database async => _db ?? await initDb();

  Future<Database?> initDb() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, "habitTracker.db");

    _db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        String sql = '''
        CREATE TABLE $tableName(
        id INTEGER NOT NULL,
        habit TEXT NOT NULL,  
        target TEXT NOT NULL,
        progress TEXT NOT NULL
        )''';
        await db.execute(sql);
      },
    );
    return _db;
  }

  Future<List<Map<String, Object?>>> getAllData() async {
    Database db = await database;
    String sql = '''SELECT * FROM $tableName''';
    return await db.rawQuery(sql);
  }

  Future<void> insertData(
      int id, String habit, String target, String progress) async {
    Database db = await database;
    String sql =
        '''INSERT INTO $tableName(id,habit,target,progress) VALUES(?,?,?,?)''';
    List args = [id, habit, target, progress];
    await db.rawInsert(sql, args);
  }

  Future<void> deleteData(int id) async {
    Database db = await database;
    String sql = '''DELETE FROM $tableName WHERE id = ?''';
    List args = [id];
    await db.rawDelete(sql, args);
  }

  Future<void> updateData(
      int id, String habit, String target, String progress) async {
    Database db = await database;
    String sql =
        '''UPDATE $tableName SET habit = ?, target = ?, progress = ? WHERE id = ?''';
    List args = [habit, target, progress, id];
    await db.rawUpdate(sql, args);
  }

  Future<bool> isExist(int id) async {
    final db = await database;
    String sql = '''SELECT * FROM $tableName WHERE id = ?''';
    List result = await db.rawQuery(sql, [id]);
    return result.isNotEmpty;
  }
}
