import 'dart:developer';
import 'package:flutter/material.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:school_timetable_app/screens/home/homeSceen.dart';
import 'package:school_timetable_app/service/sharedPreference.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CalendarClient {
  String _title, _location;
  DateTime _startTime, _endTime;
  BuildContext _context;
  static const _scopes = const [CalendarApi.CalendarScope];
  var _clientID = new ClientId(
      "1073525702507-edmtkbpeqeaohgr5l1i4qdjb5jm9ac56.apps.googleusercontent.com",
      "");

  insert(title, location, startTime, endTime, context) async {
    _title = title;
    _location = location;
    _startTime = startTime;
    _endTime = endTime;
    _context = context;
    SharedPreference _sharedPref = SharedPreference();

    bool _userGivenConsent =
        await _sharedPref.getBool("userGivenConsent") ?? false;
    if (_userGivenConsent) {
      bool tokenExpired = await _tokenExpired();
      if (tokenExpired) {
        AuthClient _client = await _refreshClient();
        _saveEvent(_client);
      } else {
        AuthClient _client = await _authenticateClient();
        _saveEvent(_client);
      }
    } else {
      AuthClient _client = await _askForUserConsent();
      _saveEvent(_client);
    }
  }

//trigger ask for user consent
  _askForUserConsent() async {
    SharedPreference _sharedPref = SharedPreference();

    try {
      AuthClient _client;
      _client = await clientViaUserConsent(_clientID, _scopes, prompt);
      //save client data
      _sharedPref.addString("type", _client.credentials.accessToken.type);
      _sharedPref.addString("data", _client.credentials.accessToken.data);
      _sharedPref.addString(
          "expiry", _client.credentials.accessToken.expiry.toString());
      _sharedPref.addString("refreshToken", _client.credentials.refreshToken);
      _sharedPref.addBool("userGivenConsent", true);
      return _client;
    } catch (error) {
      _sharedPref.addBool("userGivenConsent", false);
      throw "Error";
    }
  }

//get list of events
  Future<List<Event>> getEvents(int day, int month, int year) async {
    AuthClient _client;
    SharedPreference _sharedPref = SharedPreference();

    bool _userGivenConsent =
        await _sharedPref.getBool("userGivenConsent") ?? false;

    try {
      if (_userGivenConsent) {
        bool tokenExpired = await _tokenExpired();

        if (tokenExpired) {
          _client = await _refreshClient();
        } else {
          _client = await _authenticateClient();
        }
      } else {
        _client = await _askForUserConsent();
      }
    } catch (error) {
      print(error.toString());
      throw error;
    }

    var calendar = CalendarApi(_client);
    Events events = await calendar.events.list("primary");

    List<Event> filteredEvents = new List();
    for (Event item in events.items) {
      print(
          "${item.summary} ${item.start.dateTime.toString()} ${item.end.dateTime.toString()}");
      if (item.created.day != null &&
          item.created.month != null &&
          item.created.year != null) {
        if (item.start.dateTime.day == day &&
            item.start.dateTime.month == month &&
            item.start.dateTime.year == year) {
          filteredEvents.add(item);
        }
      }
    }

    return filteredEvents;
  }

// authenticate client
  _authenticateClient() async {
    SharedPreference _sharedPref = SharedPreference();

    AuthClient client = authenticatedClient(
        http.Client(),
        AccessCredentials(
            AccessToken(
                await _sharedPref.getStringValues("type"),
                await _sharedPref.getStringValues("data"),
                DateTime.tryParse(await _sharedPref.getStringValues("expiry"))),
            await _sharedPref.getStringValues("refreshToken"),
            _scopes));
    return client;
  }

//refresh client
  _refreshClient() async {
    SharedPreference _sharedPref = SharedPreference();
    AccessCredentials _credentials = await refreshCredentials(
        _clientID,
        AccessCredentials(
            AccessToken(
                await _sharedPref.getStringValues("type"),
                await _sharedPref.getStringValues("data"),
                DateTime.tryParse(await _sharedPref.getStringValues("expiry"))),
            await _sharedPref.getStringValues("refreshToken"),
            _scopes),
        http.Client());
    AuthClient client = authenticatedClient(http.Client(), _credentials);
    return client;
  }

// save calendar event
  _saveEvent(client) {
    var calendar = CalendarApi(client);
    calendar.calendarList.list().then(
        (CalendarList value) => print("---------->>> Lists---->>>>>>$value"));

    String calendarId = "primary";
    Event event = Event(); // Create object of event

    event.summary = _title;
    event.location = _location;

    EventDateTime start = new EventDateTime();
    start.dateTime = _startTime;
    start.timeZone = "UTC+3";
    event.start = start;

    EventDateTime end = new EventDateTime();
    end.dateTime = _endTime;
    end.timeZone = "UTC+3";
    event.end = end;

    try {
      calendar.events.insert(event, calendarId).then((value) {
        print("ADDEDDD_________________${value.status}");
        if (value.status == "confirmed") {
          log('Event added in google calendar');
          Navigator.of(_context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          log("Unable to add event in google calendar");
        }
      });
    } catch (e) {
      log('Error creating event $e');
    }
  }

//check if token has expired
  Future<bool> _tokenExpired() async {
    SharedPreference _sharedPref = SharedPreference();

    DateTime expiryDate =
        DateTime.tryParse(await _sharedPref.getStringValues("expiry"));

    return expiryDate.isBefore(DateTime.now());
  }

//prompt user to give consent
  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
