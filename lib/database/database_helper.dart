import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper extends GetxController {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE todos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        dueDate TEXT,
        priority INTEGER
      )
      '''
    );
  }

  Future<int?> insertTodo(Map<String, dynamic> todo) async {
    Database? db = await database;
    return await db?.insert('todos', todo);
  }

  Future<List<Map<String, dynamic>>?> getTodos() async {
    Database? db = await database;
    return await db?.query('todos');
  }

  Future<int?> updateTodo(Map<String, dynamic> todo, int id) async {
    Database? db = await database;
    return await db?.update('todos', todo, where: 'id = ?', whereArgs: [id]);
  }

  Future<int?> deleteTodo(int id) async {
    Database? db = await database;
    return await db?.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}
