import 'package:movement_analyzer/database/movement.dart';
import 'package:movement_analyzer/database/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  Database? _database;

  DatabaseManager._();

  static Future<DatabaseManager> create() async {
    final instance = DatabaseManager._();
    instance._connect();
    return instance;
  }

  Future<String> login(String id, String password) async {
    final db = _database;
    if (db == null) return "";

    final result = await db.query('user',
        //where: 'id = ? AND password = ?', whereArgs: [id, password]);
        where: 'id = ? AND password = ?',
        whereArgs: [id, password]);

    if (result.isNotEmpty) {
      final userAccount = result[0];
      if (userAccount.containsKey('id')) {
        final userId = userAccount['id'];
        if (userId is String) {
          return userId;
        }
      }
    }

    return "";
  }

  Future<void> saveMovement(Movement movement) async {
    final db = _database;
    if (db == null) return;

    await db.insert('movement', movement.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return;
  }

  Future<List<Map<String, Object?>>> getMovements(String userId) async {
    final db = _database;
    if (db == null) return List.empty();

    final result =
        await db.query('movement', where: 'user_id = ?', whereArgs: [userId]);
    return result;
  }

  Future<void> _connect() async {
    final databasePath = join(await getDatabasesPath(), 'database.db');
    await deleteDatabase(databasePath);
    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE user(id TEXT, password TEXT)",
        );
        db.execute("CREATE TABLE movement("
            "id INTEGER PRIMARY KEY,"
            "user_id TEXT,"
            "longitude REAL,"
            "latitude REAL,"
            "acceleration REAL,"
            "recorded_at TEXT"
            "created_at TIMESTAMP DEFAULT (datetime(CURRENT_TIMESTAMP,'localtime')))");

        // 仮のデータを挿入
        final user = User(id: 'user', password: 'pass');

        db.insert('user', user.toMap());

        return;
      },
    );
  }

  void dispose() {
    _database?.close();
  }
}
