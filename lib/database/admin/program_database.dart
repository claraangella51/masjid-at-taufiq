import 'package:masjid_berhasil/model/admin/program_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProgramDatabase {
  static final ProgramDatabase instance = ProgramDatabase._init();
  static Database? _database;

  ProgramDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "program.db");

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE program(
id INTEGER PRIMARY KEY AUTOINCREMENT,
judul TEXT,
kategori TEXT,
waktu TEXT
)
''');
      },
    );

    return _database!;
  }

  Future insert(Program program) async {
    final db = await instance.database;

    return db.insert("program", program.toMap());
  }

  Future<List<Program>> getAll() async {
    final db = await instance.database;

    final result = await db.query("program", orderBy: "id DESC");

    return result.map((e) => Program.fromMap(e)).toList();
  }

  Future update(Program program) async {
    final db = await instance.database;

    return db.update(
      "program",
      program.toMap(),
      where: "id=?",
      whereArgs: [program.id],
    );
  }

  Future delete(int id) async {
    final db = await instance.database;

    return db.delete("program", where: "id=?", whereArgs: [id]);
  }

  Future<int> countProgram() async {
    final db = await instance.database;

    final result = await db.rawQuery('SELECT COUNT(*) FROM program');

    return Sqflite.firstIntValue(result) ?? 0;
  }
}
