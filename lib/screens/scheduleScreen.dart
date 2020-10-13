import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:school_timetable_app/screens/auth/auth.dart';
import 'package:school_timetable_app/screens/home/homeSceen.dart';
import 'package:school_timetable_app/service/calenderClientApi.dart';
import 'package:school_timetable_app/utls/FadeAnimation.dart';
import 'package:school_timetable_app/utls/configs.dart';
import 'package:school_timetable_app/utls/validator.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
        builder: (context) => const ScheduleScreen(),
      );

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarClient calendarClient = CalendarClient();
  CalendarController _calendarController;
  TimeOfDay _time;
  TimeOfDay _time2;
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  bool validDataFilled = false;
  bool _autoValidate = false;
  bool validCourseFilled = false;
  bool _autoValidateCourse = false;
  GlobalKey<FormState> _userInputFormKey = GlobalKey();
  GlobalKey<FormState> _userInputCourseFormKey = GlobalKey();

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(Duration(days: 1));

  selectTime() async {
    TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: _time,
        builder: (BuildContext context, Widget child) {
          return Theme(
              data: ThemeData(
                  primaryColor: Palette.lightBlue,
                  accentColor: Palette.lightBlue),
              child: child);
        });

    if (time != null) {
      setState(() {
        _time = time;
      });
    }
  }

  selectTime2() async {
    TimeOfDay time = await showTimePicker(
        context: context,
        initialTime: _time,
        builder: (BuildContext context, Widget child) {
          return Theme(
              data: ThemeData(
                  primaryColor: Palette.lightBlue,
                  accentColor: Palette.lightBlue),
              child: child);
        });

    if (time != null) {
      setState(() {
        _time2 = time;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
    _time = TimeOfDay.now();
    _time2 = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Container(
          padding: EdgeInsets.only(bottom: 15),
          child: FloatingActionButton(
              key: Key("event"),
              backgroundColor: Palette.darkBlue,
              elevation: 10.0,
              child: Icon(
                Icons.forward,
                color: Colors.white,
              ),
              onPressed: () => {
                    setState(() {
                      _autoValidate = true;
                      _autoValidateCourse = true;
                    }),
                    if (_userInputFormKey.currentState.validate() &&
                        _userInputCourseFormKey.currentState.validate())
                      {
                        setState(() {
                          validDataFilled = !validDataFilled;
                          validCourseFilled = !validCourseFilled;
                        }),
                        if ("${startTime.hour} :  ${startTime.minute}" !=
                            "${endTime.hour} :  ${endTime.minute}")
                          {
                            calendarClient.insert(myController.text,
                                myController2.text, startTime, endTime, context)
                          }
                        else
                          {
                            Fluttertoast.showToast(
                                msg:
                                    "Please press the clock to add the correct start time and end time",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0),
                          }
                      },
                  }),
        ),
        body: Stack(children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: mediaQuery.size.height / 3,
            child: FadeAnimation(
                1.2,
                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://images.pexels.com/photos/355952/pexels-photo-355952.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                    ),
                  ),
                  child: Transform.translate(
                    offset: Offset(30, -30),
                    child: FadeAnimation(1.3, Container()),
                  ),
                )),
          ),
          Positioned(
            top: 50,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).size.height / 1.3,
              child: FadeAnimation(
                  1.2,
                  Container(
                      padding: const EdgeInsets.all(0.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      child: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildHorizontalDatesCalender(),
                          SizedBox(
                            height: 10,
                          ),
                          buildDetailIputs(),
                        ],
                      ))))),
        ]));
  }

  Container buildDetailIputs() {
    return Container(
      child: Container(
          decoration: BoxDecoration(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "Add class details!!",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildClassItem("Add start time", "Enter Class"),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildClass2Item("Add end time", "Enter Course"),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          )),
    );
  }

  Container buildMainHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 50, 24, 24),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Palette.darkOrange,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Hello',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Text(
            'Schedule your today classes',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  SingleChildScrollView _buildHorizontalDatesCalender() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            initialCalendarFormat: CalendarFormat.twoWeeks,
            calendarStyle: CalendarStyle(
                todayColor: Colors.orange,
                selectedColor: Theme.of(context).primaryColor,
                todayStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white)),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonDecoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20.0),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            onDaySelected: (date, events) {
              print(date.toIso8601String());
            },
            builders: CalendarBuilders(
              selectedDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
              todayDayBuilder: (context, date, events) => Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            calendarController: _calendarController,
          )
        ],
      ),
    );
  }

  Container buildClassItem(String time, String hint) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(10),
      height: 110,
      decoration: BoxDecoration(
        color: Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2019, 3, 5),
                      maxTime: DateTime(2200, 6, 7),
                      onChanged: (date) {}, onConfirm: (date) {
                    setState(() {
                      this.startTime = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Icon(
                  Icons.more_time_sharp,
                  color: Colors.blue,
                ),
              )
            ],
          ),
          Container(
            height: 100,
            width: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 160,
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  DateFormat('kk:mm:a').format(startTime),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Form(
                    key: _userInputFormKey,
                    child: Container(
                        width: MediaQuery.of(context).size.width - 160,
                        child: TextFormField(
                          key: Key('classKey'),
                          autovalidate: _autoValidate,
                          controller: myController,
                          validator: (value) =>
                              Validator.validateClassField(value.trim()),
                          style: TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: hint,
                          ),
                        )),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Container buildClass2Item(String time, String hint) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(10),
      height: 110,
      decoration: BoxDecoration(
        color: Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                time,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  DatePicker.showDateTimePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2019, 3, 5),
                      maxTime: DateTime(2200, 6, 7),
                      onChanged: (date) {}, onConfirm: (date) {
                    setState(() {
                      this.endTime = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Icon(
                  Icons.more_time_sharp,
                  color: Colors.blue,
                ),
              )
            ],
          ),
          Container(
            height: 100,
            width: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 160,
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  DateFormat('kk:mm:a').format(endTime),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.subject,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Form(
                    key: _userInputCourseFormKey,
                    child: Container(
                        width: MediaQuery.of(context).size.width - 160,
                        child: TextFormField(
                          key: Key('courseKey'),
                          autovalidate: _autoValidateCourse,
                          controller: myController2,
                          style: TextStyle(fontSize: 13),
                          validator: (value) =>
                              Validator.validateCourseField(value.trim()),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: hint,
                          ),
                        )),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  String returnDate() {
    var newDt = DateFormat.yMMMEd().format(DateTime.now());
    return newDt.toString();
  }
}
