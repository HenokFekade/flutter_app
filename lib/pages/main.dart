import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/year.dart';
import 'package:flutter_app/models/month.dart';
import 'package:flutter_app/models/diary.dart';
import 'package:flutter_app/models/month_year.dart';
import 'package:flutter_app/pages/editing_pages.dart';
import 'package:flutter_app/utility/utility.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiaryApp(),
    );
  }
}

class DiaryApp extends StatefulWidget{
  @override
  State createState() {
    return DiaryAppState();
  }
}

class DiaryAppState extends State<DiaryApp>{

  List<Year> years = [];

  @override
  void initState() {
    super.initState();
    this._myInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diary Holder',
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: years.length,
          itemBuilder: (context, index) => this._getYearWidgets(index),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditingPage(),));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future<void> _myInit() async{
    List<Year> data = await this._fetchData();;
    setState(() {
      years.clear();
      years.addAll(data);
    });

  }

  Widget _getYearWidgets(int index){
    Year year = years[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0,),
      child: Container(
        width: double.infinity,
        child: Card(
          shadowColor: Colors.lightBlueAccent,
          elevation: 5.0,
          child: ExpansionTile(

            title: Text(
              '${year.year}',
            ),
            children: this._getMonthWidgets(year.months),
          ),
        ),
      ),
    );
  }

  List<Widget> _getMonthWidgets(List<Month> months){
    List<Widget> widgets = [];
    for(Month month in months){
      Widget widget = Container(
        width: double.infinity,
        child: Card(
          child: ExpansionTile(
            title: Text(
              '${month.month}'
            ),
            children: this._getDiaryWidgets(month.diaries),
          ),
        ),
      );
      widgets.add(widget);
    }
    return widgets;
  }

  List<Widget> _getDiaryWidgets(List<Diary> diaries){
    List<Widget> widgets = [];
    for(Diary diary in diaries){
      Widget widget = Container(
        width: double.infinity,
        child: Card(
          child: Text(
                '${diary.diary}'
            ),
        ),
      );
      widgets.add(widget);
    }
    return widgets;
  }

  Future<List<Year>> _fetchData() async{
    Map<int,Year> yearMap = await _getYear();
    Map<int,Month> monthMap = await _getMonths();
    Map<int,MonthYear> monthYearMap = await _monthYears();
    List<Diary> diaries = await _getDiaries();
    for(Diary diary in diaries){
      monthYearMap[diary.monthYearId].diaries.add(diary);
      // print('${monthYearMap[diary.monthYearId].diaries.length}  and   ${monthYearMap[diary.monthYearId].id}');
    }
    for(MonthYear monthYear in monthYearMap.values){
      Year year = yearMap[monthYear.yearId];
      Month month = monthMap[monthYear.monthId];
      month.diaries.clear();
      month.diaries.addAll(monthYear.diaries);
      if(!year.months.contains(month)){
        yearMap[monthYear.yearId].months.add(month);
      }
    }
    // yearMap.forEach((key, year) {
    //   print('year   ${year.year}');
    //   year.months.forEach((month) {
    //     print('month   ${month.month}');
    //     month.diaries.forEach((diary) {
    //       print('day     ${diary.day}');
    //     });
    //   });
    // });

    return yearMap.values.toList();
  }
  
  Future<Map<int,Year>> _getYear() async {
    Map<int,Year> yearMap = await Year.getAll().then((years) {
      Map<int,Year> map = {};
      for(Year year in years){
        map[year.id] = year;
      }
      return map;
    });
    return yearMap;
  }

  Future<Map<int,Month>> _getMonths() async{
    Map<int,Month> monthMap = await Month.getAll().then((months) {
      Map<int,Month> map = {};
      for(Month month in months){
        map[month.id] = month;
      }
      return map;
    });
    return monthMap;
  }

  Future<Map<int,MonthYear>> _monthYears() async{
    Map<int,MonthYear> monthYearMap = await MonthYear.getAll().then((monthYears) {
      Map<int,MonthYear> map = {};
      for(MonthYear monthYear in monthYears){
        map[monthYear.id] = monthYear;
      }
      return map;
    });
    return monthYearMap;
  }

  Future<List<Diary>> _getDiaries() async{
    return await Diary.getAll();
  }

}