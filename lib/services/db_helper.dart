import 'package:donor/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  late Database database;
  Future<void> initdb() async {
    database = await openDatabase(
      join(await getDatabasesPath(), "user.db"),
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE STUDENT(ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,PHONE TEXT,AGE INT,EMAIL TEXT)",
        );
      },
    );
  }

  Future<int> insertUser(User user) async {
    await initdb();
    return await database.insert("STUDENT", user.tomap()); //NO ID HERE
  }

  Future<int> updateUser(User user) async {
    await initdb();
    return await database.update(
      "STUDENT",
      user.tomap(),
      where: "ID=?",
      whereArgs: [user.ID],
    );
  }

  Future<int> deleteUser(int id) async {
    await initdb();
    return await database.delete("STUDENT", where: "ID=?", whereArgs: [id]);
  }

  Future<int> editUser(int id, Map<String, dynamic> updatedData) async {
    await initdb();
    return await database.update(
      "STUDENT",
      updatedData,
      where: "ID = ?",
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getall() async {
    await initdb();
    return await database.query("STUDENT");
  }
}
