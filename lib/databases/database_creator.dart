import 'package:flutter_app/models/diary.dart';
import 'package:flutter_app/models/month.dart';
import 'package:flutter_app/models/month_year.dart';
import 'package:flutter_app/models/year.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseCreator{
    final String _databaseName = 'diary.db';
    Database _database;

    DatabaseCreator._();

    Future<String> _getDatabasePath() async{
      return join(await getDatabasesPath(), this._databaseName).toString();
    }

    Future<Database> _initDB() async {
      String path = await this._getDatabasePath();
      Database database = await openDatabase(path, version: 1, onCreate: (db, version) {
        db.execute(Year.createTableQuery());
        db.execute(Month.createTableQuery());
        db.execute(MonthYear.createTableQuery());
        db.execute(Diary.createTableQuery());
        for(String month in Month.monthsList) {
          db.insert('months', {'month': month});
        }
      });
      return database;
    }

    static Future<Database> getDatabase() async {
     return await DatabaseCreator._()._initDB();
    }

    Future<void> closeDatabase() async {
      if(this._database != null)
        await this._database.close();
    }
    
}