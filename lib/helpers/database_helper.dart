import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/todo.dart';

class DBHelper {
  static final _databaseName = 'todo.db';
  static final _todos_table = 'todos_table';
  static final _databaseVersion = 1;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $_todos_table('
        'id STRING PRIMARY KEY, description STRING, completed INTEGER'
        ')');
  }

  Future<int> insertTodo(Todo todo) async {
    Database? db = await DBHelper._database;
    return await db!.insert(_todos_table, todo.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await DBHelper._database;
    return await db!.query(_todos_table);
  }

  Future<int> delete(String id) async {
    Database? db = await DBHelper._database;
    return await db!.delete(_todos_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllTodos() async {
    Database? db = await DBHelper._database;
    return await db!.delete(_todos_table);
  }

  Future<int> update(String id, Todo todo) async {
    return await _database!.update(
      _todos_table,
      todo.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
