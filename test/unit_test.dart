import 'package:flutter_test/flutter_test.dart';
import 'package:school_timetable_app/utls/validator.dart';

void main() {
  //Class validation test
  test('Value Not Entered Test', () {
    var result = Validator.validateClassField('');
    expect(result, "Please enter Class Name");
  });
  test('Invalid Value Entered Test', () {
    var result = Validator.validateClassField('i');
    expect(result, "Length must be greater than 2");
  });
  test('Valid Email Entered Test', () {
    var result = Validator.validateClassField('BBIT');
    expect(result, null);
  });

//Course validation
  test('Value Not Entered Test', () {
    var result = Validator.validateCourseField('');
    expect(result, "Please enter Course Name");
  });
  test('Invalid Value Entered Test', () {
    var result = Validator.validateCourseField('i');
    expect(result, "Length must be greater than 2");
  });
  test('Valid Email Entered Test', () {
    var result = Validator.validateCourseField('BBIT');
    expect(result, null);
  });

  //start time and end time

  test('Invalid End Time', () {
    var result = Validator.validateEndTime("1132", "1132");
    expect(result, "Please select the right start time and end time");
  });

  test('Valid End Time', () {
    var result = Validator.validateEndTime("1132", "1232");
    expect(result, null);
  });
}
