import 'package:intl/intl.dart';

abstract class FormatHelper {
  static String completeAmountWithZeros(String amount) {
    var _amount = double.tryParse(amount);
    if (_amount != null) {
      return _amount.toStringAsFixed(2);
    } else {
      return "";
    }
  }

  static DateFormat userDateFormat() {
    return DateFormat.MMMEd().add_Hm();
  }
}
