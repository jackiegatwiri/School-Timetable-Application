import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:school_timetable_app/screens/auth/widget/register.dart';
import 'package:school_timetable_app/screens/auth/widget/sign_in.dart';
import 'package:school_timetable_app/screens/auth/widget/background_painter.dart';
import 'package:school_timetable_app/screens/scheduleScreen.dart';
import 'package:school_timetable_app/utls/configs.dart';

import '../home/homeSceen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  ValueNotifier<bool> showSignPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LitAuth.custom(
        errorNotification: const NotificationConfig(
          backgroundColor: Palette.darkBlue,
          icon: Icon(
            Icons.error_outline,
            color: Colors.deepOrange,
            size: 32,
          ),
        ),
        onAuthSuccess: () {
          Navigator.of(context).pushReplacement(HomeScreen.route);
        },
        child: Stack(
          children: <Widget>[
            //expnad to available size
            SizedBox.expand(
              child: CustomPaint(
                painter: BackgroundPainter(animation: _controller.view),
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: ValueListenableBuilder<bool>(
                  valueListenable: showSignPage,
                  builder: (context, value, child) {
                    return PageTransitionSwitcher(
                        reverse: !value,
                        duration: Duration(milliseconds: 800),
                        transitionBuilder:
                            (child, animation, secondaryAnimation) {
                          return SharedAxisTransition(
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.vertical,
                            fillColor: Colors.transparent,
                            child: child,
                          );
                        },
                        child: value
                            ? SignIn(
                                onRegisterClicked: () {
                                  context.resetSignInForm();
                                  showSignPage.value = false;
                                  _controller.forward();
                                },
                              )
                            : Register(
                                onSignInPressed: () {
                                  showSignPage.value = true;
                                  _controller.reverse();
                                },
                              ));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
