import 'package:flutter_core/flutter_core.dart';

/// 从common_utils组件库拷贝过来并修改部分代码，因为只需要它的一部分

/// 一些常用格式参照。可以自定义格式，例如：'yyyy/MM/dd HH:mm:ss'，'yyyy/M/d HH:mm:ss'。
/// 格式要求
/// year -> yyyy/yy   month -> MM/M    day -> dd/d
/// hour -> HH/H      minute -> mm/m   second -> ss/s
///

class DateFormats {
  static String full = 'yyyy-MM-dd HH:mm:ss';
  static String yyyyMMddHHmm = 'yyyy-MM-dd HH:mm';
  static String yyyyMMdd = 'yyyy-MM-dd';
  static String yyyyMM = 'yyyy-MM';
  static String mmDD = 'MM-dd';
  static String mmDDHHmm = 'MM-dd HH:mm';
  static String hhMMss = 'HH:mm:ss';
  static String hhMM = 'HH:mm';

  static String zhFull = 'yyyy年MM月dd日 HH时mm分ss秒';
  static String zhYyyyMMddHHmm = 'yyyy年MM月dd日 HH时mm分';
  static String zhYyyyMMdd = 'yyyy年MM月dd日';
  static String zhYyyyMM = 'yyyy年MM月';
  static String zhMMdd = 'MM月dd日';
  static String zhMMddHHmm = 'MM月dd日 HH时mm分';
  static String zhHHMMss = 'HH时mm分ss秒';
  static String zhHHmm = 'HH时mm分';
}

/// Date Util.
class DateUtil {
  static String formatDate(DateTime? dateTime, {String? format}) {
    String? value = dateTime?.toStringWithFormat(format: format);
    if (value == null) {
      return '';
    }
    return value;
  }

  /// get WeekDay.
  /// dateTime
  /// isUtc
  /// languageCode zh or en
  /// short
  static String getWeekday(DateTime? dateTime,
      {String languageCode = 'en', bool short = false}) {
    if (dateTime == null) return "";
    return dateTime.getWeekdayDesc(languageCode: languageCode, short: short);
  }

  /// get WeekDay By Milliseconds.
  static String getWeekdayByMs(int milliseconds,
      {bool isUtc = false, String languageCode = 'en', bool short = false}) {
    DateTime dateTime = milliseconds.toDateTime(isUtc: isUtc);
    return getWeekday(dateTime, languageCode: languageCode, short: short);
  }

  /// get day of year.
  /// 在今年的第几天.
  static int getDayOfYearByMs(int ms, {bool isUtc = false}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
    return dateTime.getDayOfYear();
  }

  /// is today.
  /// 是否是当天.
  static bool isToday(int? milliseconds, {bool isUtc = false, int? locMs}) {
    if (milliseconds == null || milliseconds == 0) return false;
    DateTime old =
        DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime now;
    if (locMs != null) {
      now = locMs.toDateTime();
    } else {
      now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }
    return old.year == now.year && old.month == now.month && old.day == now.day;
  }

  /// is yesterday by dateTime.
  /// 是否是昨天.
  static bool isYesterday(DateTime dateTime, DateTime locDateTime) {
    if (yearIsEqual(dateTime, locDateTime)) {
      int spDay = locDateTime.getDayOfYear() - dateTime.getDayOfYear();
      return spDay == 1;
    } else {
      return ((locDateTime.year - dateTime.year == 1) &&
          dateTime.month == 12 &&
          locDateTime.month == 1 &&
          dateTime.day == 31 &&
          locDateTime.day == 1);
    }
  }

  /// is yesterday by millis.
  /// 是否是昨天.
  static bool isYesterdayByMs(int ms, int locMs) {
    return isYesterday(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  /// is Week.
  /// 是否是本周.
  static bool isWeek(int? ms, {bool isUtc = false, int? locMs}) {
    if (ms == null || ms <= 0) {
      return false;
    }
    DateTime old1 = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
    DateTime now1;
    if (locMs != null) {
      now1 = locMs.toDateTime(isUtc: isUtc);
    } else {
      now1 = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }

    DateTime old =
        now1.millisecondsSinceEpoch > old1.millisecondsSinceEpoch ? old1 : now1;
    DateTime now =
        now1.millisecondsSinceEpoch > old1.millisecondsSinceEpoch ? now1 : old1;
    return (now.weekday >= old.weekday) &&
        (now.millisecondsSinceEpoch - old.millisecondsSinceEpoch <=
            7 * 24 * 60 * 60 * 1000);
  }

  /// year is equal.
  /// 是否同年.
  static bool yearIsEqual(DateTime dateTime, DateTime locDateTime) {
    return dateTime.year == locDateTime.year;
  }

  /// year is equal.
  /// 是否同年.
  static bool yearIsEqualByMs(int ms, int locMs) {
    return yearIsEqual(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  static int daysInMonth(final int year, final int month) {
    DateTime x1 = DateTime(year, month, 0).toUtc();
    var days = DateTime(year, month + 1, 0).toUtc().difference(x1).inDays;
    return days;
  }
}
