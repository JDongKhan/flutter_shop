import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// @author jd
class ToastUtils {
  ///初始化
  static TransitionBuilder init({
    TransitionBuilder? builder,
  }) {
    return FlutterSmartDialog.init(builder: builder);
  }

  static NavigatorObserver observer() {
    return FlutterSmartDialog.observer;
  }

  static void showLoading({String? msg}) {
    SmartDialog.showLoading(msg: msg ?? 'loading...');
  }

  static void hiddenLoading() {
    SmartDialog.dismiss();
  }

  static Future<dynamic> toast<T>(dynamic msg) async {
    msg ??= "未知信息";
    if (msg != null && msg is String) {
      await SmartDialog.showToast(msg);
      return null;
    } else {
      return toastError(msg);
    }
  }

  static FutureOr<Null> toastError(onError) async {
    String msg = '';
    if (onError is AppException) {
      msg = onError.toString();
    } else if (onError is DioError) {
      msg = onError.error.toString();
    } else {
      msg = onError.toString();
    }
    await SmartDialog.showToast(msg);
    return null;
  }
}
