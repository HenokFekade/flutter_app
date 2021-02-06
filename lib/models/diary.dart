import 'package:flutter/material.dart';
import 'package:flutter_app/models/model.dart';
import 'package:sqflite/sqflite.dart';

class Diary extends Model{
  final String _tableName = 'diaries';
  int _id;
  int _monthYearId;
  int _day;
  String _diary;

  Diary._();

  static Future<Diary> getInstance({int id, @required int monthYearId, @required int day, @required String diary}) async {
    Diary diaryObj = Diary._();
    await diaryObj.initDB();
    diaryObj._id = id;
    diaryObj._monthYearId = monthYearId;
    diaryObj._day = day;
    diaryObj._diary = diary;
    return diaryObj;
  }
  static Future<Diary> _dbForStatic() async {
    Diary diaryObj = Diary._();
    await diaryObj.initDB();
    return diaryObj;
  }

  int get id => _id;

  int get monthYearId => _monthYearId;

  String get diary => _diary;

  int get day => _day;

  static Future<Diary> fromJson(Map map) async {
    Diary diary = await Diary.getInstance(id: map['id'], monthYearId: map['month_year_id'], day: map['day'], diary: map['diary']);
    return diary;
  }

  @override
  Map<String,dynamic> toJson() {
    Map<String,dynamic> map = {
      'month_year_id': this._monthYearId,
      'day': _day,
      'diary': _diary
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

  static Future<List<Diary>> find(int id) async{
    Diary diary =  await Diary._dbForStatic();
    Database database = diary.database;
    List<Map<String, dynamic>> data  = await database.query(diary._tableName, where: 'id = ?', whereArgs: [id]);
    List<Diary> diaries = [];
    for(Map value in data){
      Diary diary = await Diary.fromJson(value);
      diaries.add(diary);
    }
    return diaries;
  }

  static Future<List<Diary>> getWhere(String where, List whereArg) async{
    Diary diary =  await Diary._dbForStatic();
    Database database = diary.database;
    List<Map<String, dynamic>> data  = await database.rawQuery('SELECT id, month_year_id, day, diary, timestamp FROM ${Diary._()._tableName} WHERE $where', whereArg);
    List<Diary> diaries = [];
    for(Map value in data){
      Diary diary = await Diary.fromJson(value);
      diaries.add(diary);
    }
    return diaries;
  }

  static Future<List<Diary>> getAll() async {
    Diary diary =  await Diary._dbForStatic();
    Database database = diary.database;
    List<Map<String, dynamic>> data  = await database.query(diary._tableName,);
    List<Diary> diaries = [];
    for(Map value in data){
      Diary diary = await Diary.fromJson(value);
      diaries.add(diary);
    }
    return diaries;
  }
  
  static String createTableQuery() {
    return 'CREATE TABLE IF NOT EXISTS diaries (id INTEGER  PRIMARY KEY AUTOINCREMENT, month_year_id INTEGER NOT NULL, day INTEGER NOT NULL, diary TEXT NOT NULL, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, FOREIGN KEY (month_year_id) REFERENCES month_years (id) ON DELETE CASCADE)';
  }


}