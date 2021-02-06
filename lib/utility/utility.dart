import 'package:flutter_app/databases/database_creator.dart';
import 'package:flutter_app/models/diary.dart';
import 'package:flutter_app/models/month.dart';
import 'package:flutter_app/models/month_year.dart';
import 'package:flutter_app/models/year.dart';
import 'package:sqflite/sqflite.dart';

class Utility{
  static Future<void> dropAllTables() async {
    Database database = await DatabaseCreator.getDatabase();
    database.execute('DROP TABLE IF EXISTS diaries');
    database.execute('DROP TABLE IF EXISTS month_years');
    database.execute('DROP TABLE IF EXISTS years');
    database.execute('DROP TABLE IF EXISTS months');
    print('all tables dropped successfully');
  }

  static Future<void> createData() async {
    List<int> yearIds = await _createYears();
    List<int> monthIds = await _getMonthIds();
    List<int> monthYearIds = await _createMonthYears(monthIds, yearIds);
    _createDiaries(monthYearIds);
  }

  static Future<List<int>> _createYears() async {
    Database database = await DatabaseCreator.getDatabase();
    List<int> ids = [];
    // for(int i = 0; i < 10; i++){
    //   Year year = await Year.getInstance(year: 2000 + i);
    //   int id = await database.insert('years', year.toJson());
    //   ids.add(id);
    // }
    var data = await Year.getAll();
    for(Year year in data){
      ids.add(year.id);
    }
    print('years created successfully');
    return ids;
  }

  static Future<List<int>> _getMonthIds() async {
    Database database = await DatabaseCreator.getDatabase();
    List<int> ids = [];
    List<Month> months = await Month.getAll();
    for(Month month in months){
      ids.add(month.id);
    }
    return ids;
  }

  static Future<List<int>> _createMonthYears(List<int> monthIds, List<int> yearIds) async {
    Database database = await DatabaseCreator.getDatabase();
    List<int> ids = [];
    for(int yearId in yearIds){
     for(int monthId in monthIds){
       MonthYear monthYear = await MonthYear.getInstance(monthId: monthId, yearId: yearId);
       int id = await monthYear.create();
       ids.add(id);
     }
    }
    print('montYears created successfully');
    return ids;
  }

  static Future<void> _createDiaries(List<int> monthYearIds) async {
    Database database = await DatabaseCreator.getDatabase();
    for(int myID in monthYearIds){
      for(int i = 0; i < 30; i++){
        Diary diary = await Diary.getInstance(monthYearId: myID, day: i + 1, diary: 'diary day ${i+1} Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ab adipisci architecto asperiores at atque autem, blanditiis consectetur deserunt dignissimos dolorem enim error excepturi explicabo id illum incidunt inventore pariatur placeat porro quibusdam quis quo reprehenderit saepe similique tempora tempore veritatis voluptatem. Blanditiis commodi dolorem facilis ipsa laudantium nostrum quidem temporibus?');
        await database.insert('diaries', diary.toJson());
      }
    }
    print('diary created successfully');
  }

  // List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
}