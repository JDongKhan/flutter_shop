import 'package:flutter_core/flutter_core.dart';

extension ExtensionNum on num {
  /// Checks if num data is LOWER than comparedTo.
  bool isLowerThan(num compareTo) => this < compareTo;

  /// Checks if num data is GREATER than comparedTo.
  bool isGreaterThan(num compareTo) => this > compareTo;

  /// Checks if num data is EQUAL to compared one.
  bool isEqualTo(num compareTo) => this == compareTo;

  DateTime toDateTime({bool isUtc = false}) {
    int ms = toInt();
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }

  /// format date by milliseconds.
  /// milliseconds 日期毫秒
  String toDateTimeString({bool isUtc = false, String? format}) {
    DateTime dateTime = toDateTime(isUtc: isUtc);
    return dateTime.toStringWithFormat(format: format);
  }

  double get pt {
    return getFontSize(toDouble());
  }
}
