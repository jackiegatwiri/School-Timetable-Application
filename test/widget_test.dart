import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_timetable_app/screens/scheduleScreen.dart';

void main() {
  Widget _makeTestable(Widget child) {
    return MaterialApp(
      home: child,
    );
  }

  var classField = find.byKey(Key("classKey"));
  var courseField = find.byKey(Key("courseField"));
  var icon = find.byKey(Key("event"));

  group("class details test", () {
    testWidgets('class, course and icon are found',
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(ScheduleScreen()));
      expect(classField, findsOneWidget);
      expect(courseField, findsOneWidget);
      expect(icon, findsOneWidget);
    });
    testWidgets("validates empty class and course",
        (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(ScheduleScreen()));
      await tester.tap(icon);
      await tester.pump();
      expect(find.text("Please Enter Class"), findsOneWidget);
      expect(find.text("Please Enter Course"), findsOneWidget);
    });

    testWidgets("course and class is entered", (WidgetTester tester) async {
      await tester.pumpWidget(_makeTestable(ScheduleScreen()));
      await tester.enterText(courseField, "BBIT");
      await tester.enterText(classField, "BIT");
      await tester.tap(icon);
      await tester.pump();
    });
  });
}
