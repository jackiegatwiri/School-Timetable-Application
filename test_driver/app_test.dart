import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_test/flutter_test.dart' as test;

void main() {
  test.group("Flutter Test", () {
    final classField = find.byValueKey("classKey");
    final courseField = find.byValueKey("courseKey");
    final icon = find.byValueKey("event");

    FlutterDriver driver;
    test.setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    test.tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test.test("Event posting fails with incorrect data", () async {
      await driver.tap(classField);
      await driver.enterText("BBIT");
      await driver.tap(courseField);
      await driver.enterText("test");
      await driver.tap(icon);

      await driver.waitUntilNoTransientCallbacks();
    });

    test.test("Event sent with correct data", () async {
      await driver.tap(classField);
      await driver.enterText("test@testmail.com");
      await driver.tap(courseField);
      await driver.enterText("testtest1");
      await driver.tap(icon);
      await driver.waitUntilNoTransientCallbacks();
    });
  });
}
