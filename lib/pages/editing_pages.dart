import 'package:flutter/material.dart';
import 'package:flutter_app/models/diary.dart';
import 'package:flutter_app/models/month.dart';
import 'package:flutter_app/models/month_year.dart';
import 'package:flutter_app/models/year.dart';
import 'package:flutter_app/utility/utility.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditingPage extends StatelessWidget{

  final TextEditingController _textEditingController = TextEditingController();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(
          'Edit your diary',
        ),
        actions: [
          FlatButton(
            child: Text(
              'save',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Roboto_Condensed',

              ),
            ),
            onPressed: () => _onSave(context),
          ),
          PopupMenuButton(
              onSelected: (value) { },
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text(
                    'change font',
                  ),
                  value: 1,
                ),
              ],
          ),
        ],
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: TextField(
              controller: _textEditingController,
              maxLines: 99999,
              style: TextStyle(
                fontFamily: 'Caveat',
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                hintText: 'what happen today?',
                hintStyle: TextStyle(
                  fontFamily: 'Caveat',
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              keyboardType: TextInputType.multiline,
              autofocus: false,
            ),
          ),
      ),
    );
  }

  Future<void> _onSave(BuildContext context) async {
    if(this._textEditingController.text.trim().isNotEmpty){
      String text = this._textEditingController.text;
      DateTime dateTime = DateTime.now();
      String monthName = Month.monthsList[dateTime.month - 1];
      int monthId = await _getMonthId(monthName);
      int yearId = await _getYearId();
      int monthYearId = await _getMonthYearId(monthId, yearId);
      _saveDiary(monthYearId, text, context);
    }
    else{
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'No Diary written!',
        timeInSecForIosWeb: 1,
      );
    }
  }
  
  Future<int> _getMonthId(String monthName) async {
    Month month = await Month.getWhere('month', [monthName]).then((value) {
      if(value.isNotEmpty)
        return value.first;
      return null;
    });
    int monthId;
    if(month == null){
      monthId = DateTime.now().day - 1;
    }
    else{
      monthId = month.id;
    }
    return monthId;
  }

  Future<int> _getYearId() async {
    Year year = await Year.getWhere('year', [DateTime.now().year.toString()]).then((value) {
      if(value.isNotEmpty)
        return value.first;
      return null;
    });
    int yearId;
    if(year == null){
      year = await Year.getInstance(year: DateTime.now().year);
      yearId = await year.create();
    }
    else{
      yearId = year.id;
    }
    return yearId;
  }

  Future<int> _getMonthYearId(int monthId, int yearId) async {
    MonthYear monthYear = await MonthYear.getWhere('month_id = ? AND year_id = ?', [monthId, yearId]).then((value) {
      if(value.isNotEmpty)
        return value.first;
      return null;
    });
    int monthYearId;
    if(monthYear == null){
      monthYear = await MonthYear.getInstance(monthId: monthId, yearId: yearId);
      monthYearId = await monthYear.create();
    }
    else{
      monthYearId = monthYear.id;
    }
    return monthYearId;
  }
  
  Future<void> _saveDiary(int monthYearId, String text, BuildContext context) async {
    Diary diary = await Diary.getWhere('month_year_id = ? AND day = ?', [monthYearId, DateTime.now().day]).then((value) {
      if(value.isNotEmpty)
        return value.first;
      return null;
    });
    if(diary == null){
      diary = await Diary.getInstance(monthYearId: monthYearId, day: DateTime.now().day, diary: text);
      monthYearId = await diary.create();
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Diary created successfully',
        timeInSecForIosWeb: 1,
      );
    }
    else{
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (
          context) => AlertDialog(
            title: Text(
                'Do you want to update today\'s diary?',
              textAlign: TextAlign.center,
              ),
              content:  Text(
                    'You already have a diary on this day. please select "yes" if you want to update it.',
                    textAlign: TextAlign.center,
                  ),
            actions: [
              FlatButton(
                  onPressed: () async {
                    await diary.update();
                    Fluttertoast.cancel();
                    Fluttertoast.showToast(
                      msg: 'Diary updated successfully',
                      timeInSecForIosWeb: 1,
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'yes',
                  ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'no',
                ),
              ),
            ],
          ),
      );
    }

  }
}