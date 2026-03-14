import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  /// SINGLETON
  static final UserDatabase instance = UserDatabase._init();

  static Database? _database;

  UserDatabase._init();

  /// GET DATABASE
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('users.db');
    return _database!;
  }

  /// INIT DATABASE
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// CREATE TABLE
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        password TEXT,
        isAdmin INTEGER
      )
    ''');

    /// INSERT ADMIN DEFAULT
    await db.insert("users", {
      "name": "Admin",
      "email": "admin@gmail.com",
      "phone": "08123456789",
      "password": "123456",
      "isAdmin": 1,
    });
  }

  /// REGISTER USER
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert("users", user);
  }

  /// LOGIN
  Future<List<Map<String, dynamic>>> login(
    String email,
    String password,
  ) async {
    final db = await database;

    return await db.query(
      "users",
      where: "email = ? AND password = ?",
      whereArgs: [email, password],
    );
  }

  /// GET USER
  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;

    final result = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return result.first;
    }

    return null;
  }

  /// UPDATE PROFILE
  Future<int> updateUser(String email, Map<String, dynamic> user) async {
    final db = await database;

    return await db.update(
      "users",
      user,
      where: "email = ?",
      whereArgs: [email],
    );
  }
}
