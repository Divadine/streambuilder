import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:fullproject/models/users.dart';
import 'package:fullproject/data/state_city_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  Database? _db;

  final _streamController = StreamController<List<Users>>.broadcast();
  Stream<List<Users>> get userStream => _streamController.stream;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          firstName TEXT,
          lastName TEXT,
          phone TEXT,
          password TEXT,
          gender TEXT,
          dob TEXT,
          profilePic TEXT,
          state_id INTEGER,
          city_id INTEGER
        )
      ''');
    });
  }

  Future<void> refreshUsers() async {
    final db = await database;
    final res = await db.query('users', orderBy: 'id DESC');

    final users = res.map((e) {
      final u = Users.fromMap(e);
      u.selectedState = states.firstWhere((s) => s.id == e['state_id']);
      u.selectedCity =
          u.selectedState!.cities.firstWhere((c) => c.id == e['city_id']);
      return u;
    }).toList();

    _streamController.add(users);
  }

  Future<void> insertUser(Users u) async {
    final db = await database;
    await db.insert('users', u.toMap());
    refreshUsers();
  }

  Future<void> updateUser(Users u) async {
    final db = await database;
    await db.update('users', u.toMap(),
        where: 'id=?', whereArgs: [u.id]);
    refreshUsers();
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id=?', whereArgs: [id]);
    refreshUsers();
  }
}
