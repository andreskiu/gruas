class CoreTransformations {
  static DateTime? stringToDate(String date) {
    return DateTime.tryParse(date);
  }

  static String dateToString(DateTime date) {
    return date.toIso8601String();
  }

  static DateTime? intToDate(int dateMillis) {
    return DateTime.fromMillisecondsSinceEpoch(dateMillis);
  }

  static int? dateToInt(DateTime? date) {
    return date?.millisecondsSinceEpoch;
  }

  static DateTime? dynamicToDate(dynamic value) {
    DateTime? _date;
    try {
      if (value is int) {
        _date = DateTime.fromMillisecondsSinceEpoch(value);
      } else if (value is String) {
        _date = DateTime.tryParse(value)?.toLocal();
      }
      return _date;
    } catch (e) {
      return null;
    }
  }

  static dynamic dateToDynamic<T>(DateTime date) {
    if (T is int) {
      return date.millisecondsSinceEpoch;
    } else if (T is String) {
      return date.toUtc().toIso8601String();
    }
    return null;
  }
}
