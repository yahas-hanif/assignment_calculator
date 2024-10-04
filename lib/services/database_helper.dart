import 'dart:convert';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import '../app/method.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'ocr_results.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE results(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        detectedText BLOB,
        result BLOB
      )
    ''');
  }

  Future<void> insertResult(String detectedText, String result) async {
    final db = await database;

    final encryptedText = encryptText(detectedText);
    final encryptedResult = encryptText(result);

    await db.insert(
      'results',
      {
        'detectedText': utf8.encode(encryptedText),
        'result': utf8.encode(encryptedResult),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getResults() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('results');

    return maps
        .map((e) => {
              'detectedText': decryptText(utf8.decode(e['detectedText'])),
              'result': decryptText(utf8.decode(e['result'])),
            })
        .toList();
  }
}
