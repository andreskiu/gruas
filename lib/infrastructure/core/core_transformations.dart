class CoreTransformations {
  static DateTime? stringToDate(String date) {
    return DateTime.tryParse(date);
  }

  static String dateToString(DateTime date) {
    return date.toIso8601String();
  }
}
