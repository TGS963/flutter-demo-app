import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'db.dart';

Future<Database> createDatabase() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'user_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT, password TEXT, loginTime INTEGER, loggedIn BOOLEAN)",
      );
    },
    version: 1,
  );
  return database;
}

String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

final database = createDatabase();

Future<void> insertUser(User user) async {
  final db = await database;

  await db.insert(
    'users',
    user.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<User>> getUsers() async {
  final db = await database;

  final List<Map<String, dynamic>> maps = await db.query('users');

  return List.generate(maps.length, (i) {
    return User(
      id: maps[i]['id'],
      email: maps[i]['email'],
      password: maps[i]['password'],
      loginTime: maps[i]['loginTime'],
      loggedIn: maps[i]['loggedIn'] == 1,
    );
  });
}

Future<void> updateUserLoginTime(int id, int loginTime) async {
  final db = await database;

  await db.update(
    'users',
    {'loginTime': loginTime},
    where: "id = ?",
    whereArgs: [id],
  );
}
