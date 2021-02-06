import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/model.dart';
import 'package:flutter_app/models/month.dart';
import 'package:sqflite/sqflite.dart';

import 'year.dart';

class Year extends Model{
  final String _tableName = 'years';
  int _id;
  int _year;
  List<Month> months = [];

  Year._();

  static Future<Year> getInstance({int id, @required int year}) async {
    Year yearObj = Year._();
    await yearObj.initDB();
    yearObj._id = id;
    yearObj._year = year;
    return yearObj;
  }

  static Future<Year> _dbForStatic() async {
    Year yearObj = Year._();
    await yearObj.initDB();
    return yearObj;
  }

  int get id => _id;

  int get year => _year;

  static Future<Year> fromJson(Map map) async {
    Year year = await Year.getInstance(id: map['id'], year: map['year']);
    return year;
  }

  Map<String,dynamic> toJson() {
    Map<String,dynamic> map = {
      'year': this._year
    };
    return map;
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

  @override
  Future<bool> dropTable() async {
    await this.database.execute('DROP TABLE IF EXISTS $_tableName');
    return true;
  }

  static Future<List<Year>> find(int id) async{
    Year year =  await Year._dbForStatic();
    Database database = year.database;
    List<Map<String, dynamic>> data  = await database.query(year._tableName, where: 'id = ?', whereArgs: [id]);
    List<Year> years = [];
    for(Map value in data){
      Year year = await Year.fromJson(value);
      years.add(year);
    }
    return years;
  }

  static Future<List<Year>> getWhere(String where, List whereArg) async{
    Year year = await Year._dbForStatic();
    Database database = year.database;
    List<Map<String, dynamic>> data  = await database.query(year._tableName, where: '$where = ?', whereArgs: whereArg);
    List<Year> years = [];
    for(Map value in data){
      Year year = await Year.fromJson(value);
      years.add(year);
    }
    return years;
  }

  static Future<List<Year>> getAll() async {
    Year year =  await Year._dbForStatic();
    Database database = year.database;
    List<Map<String, dynamic>> data  = await database.query(year._tableName);
    List<Year> years = [];
    for(Map value in data){
      Year year = await Year.fromJson(value);
      years.add(year);
    }
    return years;
  }

  static String createTableQuery() {
    return 'CREATE TABLE IF NOT EXISTS years (id INTEGER  PRIMARY KEY AUTOINCREMENT, year INTEGER NOT NULL UNIQUE)';
  }  
}