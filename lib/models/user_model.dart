import 'package:flutter_app/models/model.dart';
import 'package:sqflite/sqflite.dart';

class UserModel extends Model {
  final String _tableName = 'years';

  UserModel._();

  static Future<UserModel> getInstance() async {
    UserModel modelTest = UserModel._();
    await modelTest.initDB();
    return modelTest;
  }

  Future<Database> _dbForStatic() async {
    UserModel modelTest = UserModel._();
    await modelTest.initDB();
    return modelTest.database;
  }

  @override
  Map<String,dynamic> toJson() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  static UserModel fromJson(Map<String, dynamic> map) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<int> create() async {
    return await database.insert(this._tableName, this.toJson());
  }

  @override
  Future<int> update() async {
    return await database.update(this._tableName, this.toJson());
  }

  @override
  Future<int> delete() async {
    return await database.delete(this._tableName);
  }

  @override
  Future<bool> deleteAllData() async {
    await this.database.execute('DELETE FROM $_tableName');
    return true;
  }

  static String createTableQuery() {
    return 'CREATE TABLE IF NOT EXISTS years (id INTEGER  PRIMARY KEY AUTOINCREMENT, year INTEGER NOT NULL UNIQUE)';
  }

  @override
  Future<bool> dropTable() async {
    await this.database.execute('DROP TABLE IF EXISTS $_tableName');
    return true;
  }
}