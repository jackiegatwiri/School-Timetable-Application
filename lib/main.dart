import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:school_timetable_app/screens/auth/auth.dart';
import 'package:school_timetable_app/screens/home/homeSceen.dart';
import 'package:school_timetable_app/screens/scheduleScreen.dart';
import 'package:school_timetable_app/utls/configs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LitAuthInit(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: GoogleFonts.muliTextTheme(),
            accentColor: Palette.darkOrange,
            appBarTheme: const AppBarTheme(
              brightness: Brightness.dark,
              color: Palette.darkBlue,
            ),
            primaryColor: Color(0xff463333),
            primaryColorLight: Color(0xff463333),
          ),
          home: LitAuthState(
            authenticated: HomeScreen(),
            unauthenticated: AuthScreen(),
          )),
    );
  }
}
