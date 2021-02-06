import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/model.dart';
import 'package:sqflite/sqflite.dart';
import 'diary.dart';

class MonthYear extends Model{
  final String _tableName = 'month_years';
  int _id;
  int _monthId;
  int _yearId;
  List<Diary> diaries = [];

  MonthYear._();

  static Future<MonthYear> getInstance({int id, @required int monthId, @required int yearId}) async {
    MonthYear monthYearYearObj = MonthYear._();
    await monthYearYearObj.initDB();
    monthYearYearObj._id = id;
    monthYearYearObj._monthId = monthId;
    monthYearYearObj._yearId = yearId;
    return monthYearYearObj;
  }

  static Future<MonthYear> _dbForStatic() async {
    MonthYear monthYearYearObj = MonthYear._();
    await monthYearYearObj.initDB();
    return monthYearYearObj;
  }

  int get id => _id;

  int get monthId => _monthId;

  int get yearId => _yearId;

  static Future<MonthYear> fromJson(Map map) async {
    MonthYear monthYear = await MonthYear.getInstance(id: map['id'], monthId: map['month_id'], yearId: map['year_id']);
    return monthYear;
  }

  Map<String,dynamic> toJson() {
    Map<String,dynamic> map = {
      'month_id': this._monthId,
      'year_id': this._yearId
    };
    return map;
  }

  @override
  Future<int> create() async {
    int lastId = await database.query(_tableName, columns: ['id'], orderBy: 'id DESC').then((value) {
      if(value.isNotEmpty)
        return value.first['id'];
      return null;
    });
    Map<String,dynamic> map = this.toJson();
    map['id'] = (lastId == null) ? 1 : lastId + 1;
    return await database.insert(this._tableName, map);
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

  static Future<List<MonthYear>> find(int id) async{
    MonthYear monthYear =  await MonthYear._dbForStatic();
    Database database = monthYear.database;
    List<Map<String, dynamic>> data  = await database.query(monthYear._tableName, where: 'id = ?', whereArgs: [id]);
    List<MonthYear> monthYears = [];
    for(Map value in data){
      MonthYear monthYear = await MonthYear.fromJson(value);
      monthYears.add(monthYear);
    }
    return monthYears;
  }

  static Future<List<MonthYear>> getWhere(String where, List whereArg) async{
    MonthYear monthYear = await MonthYear._dbForStatic();
    Database database = monthYear.database;
    List<Map<String, dynamic>> data  = await database.rawQuery('SELECT id, month_id, year_id FROM ${MonthYear._()._tableName} WHERE $where', whereArg);
    List<MonthYear> monthYears = [];
    for(Map value in data){
      MonthYear monthYear = await MonthYear.fromJson(value);
      monthYears.add(monthYear);
    }
    return monthYears;
  }

  static Future<List<MonthYear>> getAll() async {
    MonthYear monthYear =  await MonthYear._dbForStatic();
    Database database = monthYear.database;
    List<Map<String, dynamic>> data  = await database.query(monthYear._tableName,);
    List<MonthYear> monthYears = [];
    for(Map value in data){
      MonthYear monthYear = await MonthYear.fromJson(value);
      monthYears.add(monthYear);
    }
    return monthYears;
  }

  static String createTableQuery() {
    return 'CREATE TABLE IF NOT EXISTS ${MonthYear._()._tableName}(id INTEGER NOT NULL UNIQUE, month_id INTEGER NOT NULL, year_id INTEGER NOT NULL, PRIMARY KEY (month_id, year_id), FOREIGN KEY (month_id) REFERENCES months (id) ON DELETE CASCADE, FOREIGN KEY (year_id) REFERENCES years (id) ON DELETE CASCADE)';
  }

}