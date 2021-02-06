import 'package:flutter_app/databases/database_creator.dart';
import 'package:sqflite/sqflite.dart';

abstract class Model {
  String databaseName;
  String tableName;
  Database database ;

  Map<String,dynamic> toJson();
  Future<int> create();
  Future<int> update();
  Future<int> delete();
  Future<bool> deleteAllData();
  Future<bool> dropTable();
  
  Future<void> initDB() async{
    this.databaseName = databaseName;
    this.database = await DatabaseCreator.getDatabase();
  }


}