import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }

    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'expenses.db');

    // Check if the database already exists
    bool databaseExists = await File(path).exists();

    if (!databaseExists) {
      // Create the database
      Database database =
          await openDatabase(path, version: 1, onCreate: _createDb);
      return database;
    } else {
      // Open the existing database
      Database database = await openDatabase(path, version: 1);
      return database;
    }
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        value INTEGER,
        label TEXT,
        type TEXT,
        date INTEGER
      )
    ''');
  }

  Future<int> saveEntry(Entry entry) async {
    Database db = await database;
    int id = await db.insert('entries', entry.toMap());
    return id;
  }

  Future<List<Entry>> getEntries() async {
    Database db = await database;
    List<Map<String, dynamic>> maps =
        await db.query('entries', orderBy: 'date DESC');
    return List.generate(maps.length, (index) => Entry.fromMap(maps[index]));
  }

  Future<void> updateEntry(int id, Entry entry) async {
    final db = await database;
    await db.update(
      'entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteEntry(int id) async {
    Database db = await database;
    await db.delete('entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllEntries() async {
    Database db = await database;
    await db.delete('entries');
  }
}
