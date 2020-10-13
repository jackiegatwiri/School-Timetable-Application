import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/calendar/v3.dart' as v3;
import 'package:intl/intl.dart';
import 'package:school_timetable_app/screens/home/detailsCard.dart';
import 'package:school_timetable_app/screens/scheduleScreen.dart';
import 'package:school_timetable_app/service/calenderClientApi.dart';
import 'package:school_timetable_app/utls/FadeAnimation.dart';
import 'package:school_timetable_app/utls/configs.dart';
import 'package:table_calendar/table_calendar.dart';

import '../auth/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  static MaterialPageRoute get route => MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarController _calendarController;
  DateTime _dateTime;
  Future<List<v3.Event>> filteredEvents;
  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 15),
        child: FloatingActionButton(
            backgroundColor: Palette.darkBlue,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ScheduleScreen()))
                }),
      ),
      body: Stack(
        children: <Widget>[
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
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          colors: [
                        Color.fromRGBO(66, 165, 245, 1.0),
                        Color(0xff35B5AC)
                      ])),
                  child: Transform.translate(
                    offset: Offset(30, -30),
                    child: FadeAnimation(1.3, Container()),
                  ),
                )),
          ),
          Positioned(
            top: 20,
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
                            builder: (context) => AuthScreen()));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              Text(
                                "Hello Tutor",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                returnDate(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 180,
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 1, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.2),
                            blurRadius: 12,
                            spreadRadius: 8,
                          )
                        ],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://images.pexels.com/photos/4145190/pexels-photo-4145190.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                        ),
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
                        ],
                      ))))),
        ],
      ),
    );
  }

  String returnDate() {
    var newDt = DateFormat.yMMMEd().format(DateTime.now());
    return newDt.toString();
  }

  SingleChildScrollView _buildHorizontalDatesCalender() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TableCalendar(
            initialCalendarFormat: CalendarFormat.week,
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
              if (date != null) {
                setState(() {
                  load = true;
                  filteredEvents = CalendarClient()
                      .getEvents(date.day, date.month, date.year);
                });
              }
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
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Lesson Plan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 400,
            child: FutureBuilder(
                future: filteredEvents,
                builder: (context, snapshot) {
                  load = false;
                  if (snapshot.data == null) {
                    return Container(
                      child: load
                          ? Center(child: CircularProgressIndicator())
                          : Center(
                              child:
                                  Text("No events added yet on this date!!")),
                    );
                  }
                  if (snapshot.hasError) {
                    return Container(
                      child: load
                          ? Center(child: CircularProgressIndicator())
                          : Text(snapshot.error.toString()),
                    );
                  } else {}

                  return load
                      ? Center(child: CircularProgressIndicator())
                      : snapshot.data.length > 0
                          ? ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              padding: EdgeInsets.only(top: 10),
                              itemBuilder: (context, index) {
                                return DetailsCard(
                                  event: snapshot.data[index],
                                );
                              })
                          : Container(
                              child: Center(
                                  child: Text(
                                      "No events added yet on this date!!")),
                            );
                }),
          ),
        ],
      ),
    );
  }
}
