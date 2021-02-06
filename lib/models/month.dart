import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/model.dart';
import 'package:flutter_app/models/diary.dart';
import 'package:sqflite/sqflite.dart';

import 'month.dart';

class Month extends Model{
  final String _tableName = 'months';
  int _id;
  String _month;
  List<Diary> diaries = [];

  Month._();

  static Future<Month> getInstance({int id, @required String month}) async {
    Month monthObj = Month._();
    await monthObj.initDB();
    monthObj._id = id;
    monthObj._month = month;
    return monthObj;
  }
  
  static Future<Month> _dbForStatic() async {
    Month monthObj = Month._();
    await monthObj.initDB();
    return monthObj;
  }

  int get id => _id;

  String get month => _month;

  static Future<Month> fromJson(Map map) async {
    Month month = await Month.getInstance(id: map['id'], month: map['month']);
    return month;
  }

  Map<String,dynamic> toJson() {
    Map<String,dynamic> map = {
      'month': this._month
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

  static Future<List<Month>> find(int id) async{
    Month month =  await Month._dbForStatic();
    Database database = month.database;
    List<Map<String, dynamic>> data  = await database.query(month._tableName, where: 'id = ?', whereArgs: [id]);
    List<Month> months = [];
    for(Map value in data){
      Month month = await Month.fromJson(value);
      months.add(month);
    }
    return months;
  }

  static Future<List<Month>> getWhere(String where, List whereArg) async{
    Month month = await Month._dbForStatic();
    Database database = month.database;
    List<Map<String, dynamic>> data  = await database.query(month._tableName, where: '$where = ?', whereArgs: whereArg);
    List<Month> months = [];
    for(Map value in data){
      Month month = await Month.fromJson(value);
      months.add(month);
    }
    return months;
  }

  static Future<List<Month>> getAll() async {
    Month month =  await Month._dbForStatic();
    Database database = month.database;
    List<Map<String, dynamic>> data  = await database.query(month._tableName,);
    List<Month> months = [];
    for(Map value in data){
      Month month = await Month.fromJson(value);
      months.add(month);
    }
    return months;
  }

  static String createTableQuery() {
    return 'CREATE TABLE IF NOT EXISTS months (id INTEGER  PRIMARY KEY AUTOINCREMENT, month TEXT NOT NULL UNIQUE)';
  }

  static List<String> monthsList = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
}