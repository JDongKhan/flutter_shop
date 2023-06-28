import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../utils/transform_utils.dart';
import 'extension_datetime.dart';

extension ExtensionString on String {
  /// Checks if string is num (int or double).
  bool isNum() => num.tryParse(this) != null;

  /// 为了解决系统排版时，中文 和 英文 交界处 换行的问题。向文本中加入一个 Zero-width space (\u{200B})
  String get joinZeroWidthSpace => Characters(this).join('\u{200B}');

  String appendString(String? string) {
    if (string == null) {
      return this;
    }
    return this + string;
  }

  /// Transform string to int type
  int toInt() {
    int? i = int.tryParse(this);
    if (i != null) return i;
    return 0;
  }

  /// Transform string to double type
  double toDouble() {
    double? d = double.tryParse(this);
    if (d != null) return d;
    return 0.0;
  }

  /// Transform string to num type
  num? toNum() => num.tryParse(this);

  String basename() => path.basename(this);
  String basenameWithoutExtension() => path.basenameWithoutExtension(this);

  /************************ toDateTime ******************/
  /// Transform String millisecondsSinceEpoch (DateTime) to DateTime
  DateTime? toDateTime({bool? isUtc}) {
    int ms = toInt();
    if (ms != 0) {
      return DateTime.fromMillisecondsSinceEpoch(ms);
    }
    DateTime? dateTime = DateTime.tryParse(this);
    if (isUtc != null) {
      if (isUtc) {
        dateTime = dateTime?.toUtc();
      } else {
        dateTime = dateTime?.toLocal();
      }
    }
    return dateTime;
  }

  int? toDateTimeMillisecondsSinceEpoch({bool? isUtc}) {
    DateTime? dateTime = toDateTime(isUtc: isUtc);
    return dateTime?.millisecondsSinceEpoch;
  }

  /// format date by date str.
  /// dateStr 日期字符串
  String? formatDateString({bool? isUtc, String? format}) {
    DateTime? dateTime = toDateTime(isUtc: isUtc);
    return dateTime?.toStringWithFormat(format: format);
  }

  /// Transform string value to binary
  /// Example: 15 => 1111
  String? toBinary() {
    if (!isNum()) {
      return null;
    }
    return TransformUtils.toBinary(int.parse(this));
  }

  ///计算文本大小
  Size getBoundingTextSize(
    TextStyle style, {
    BuildContext? context,
    int maxLines = 2 ^ 31,
    double maxWidth = double.infinity,
  }) {
    if (isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,

        ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的 机型：华为 mate 9
        locale: context != null ? Localizations.localeOf(context) : null,
        text: TextSpan(text: this, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
}
