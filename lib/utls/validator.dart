class Validator {
  //textformfield validation method
  static String validateCourseField(String value) {
    if (value.isEmpty) {
      return "Please enter Course Name";
    }

    if (value.length < 2) {
      return "Length must be greater than 2";
    }
    return null;
  }

  static String validateClassField(String value) {
    if (value.isEmpty) {
      return "Please enter Class Name";
    }

    if (value.length < 2) {
      return "Length must be greater than 2";
    }
    return null;
  }

  static String validateEndTime(String startTime, String endTime) {
    if (startTime == endTime) {
      return "Please select the right start time and end time";
    }
    return null;
  }
}
