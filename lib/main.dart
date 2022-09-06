import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_shop/page/error/error_page.dart';
import 'package:flutter_shop/utils/app_info.dart';

import 'app.dart';
import 'service/environment.dart';

void main() {
  //可以从编译参数获取环境变量，用以更改
  const String env = String.fromEnvironment('Env', defaultValue: 'prd');
  //初始化环境配置
  environments.init(env: env);

  if (Platform.isAndroid || Platform.isIOS) {
    // Some android/ios specific code
    //ios、android相关代码
    _initIOSAndAndroid();
  } else {
    _initOther();
    // Some web specific code there
  }
}

//初始化Android和iOS
void _initIOSAndAndroid() {
  //ios、android相关代码
  FlutterBugly.postCatchedException(() {
    _initProject();
  }, handler: (FlutterErrorDetails details) {
    //继续打印到控制台
    FlutterError.dumpErrorToConsole(details, forceReport: true);
  });
}

//初始化web或desktop
void _initOther() {
  FlutterError.onError = (FlutterErrorDetails details) {
    //继续打印到控制台
    FlutterError.dumpErrorToConsole(details, forceReport: true);
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };
  // Some desktop specific code there
  runZonedGuarded(() {
    _initProject();
  }, (error, stackTrace) {
    //TODO 此处可以上传到自己的服务器
    reportErrorAndLog(error, stackTrace);
  });
}

void _initProject() async {
  // window.onDrawFrame = null;
  // window.onBeginFrame = null;

  //错误信息提示
  ErrorWidget.builder = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
    return ErrorPage("${details.exception}\n ${details.stack}", details);
  };

  // Isolate.current.addErrorListener(RawReceivePort(
  //   (dynamic pair) async {
  //     //上报isolate里面的异常。
  //     print(pair);
  //   },
  // ).sendPort);

  //初始化
  AppInfo.init(() {
    if (kDebugMode) {
      runApp(
        _mainApp(),
      );
    } else {
      runApp(
        _mainApp(),
      );
    }
  });
}

Widget _mainApp() {
  return const MyApp();
}

///收集日志
void collectLog(String line) {
  //TODO 采集日志到平台
}

///收集崩溃
void reportErrorAndLog(Object error, StackTrace stackTrace) {
  // 上报错误和日志逻辑
  // print(details);
}

FlutterErrorDetails? makeDetails(Object obj, StackTrace stack) {
  ///构建错误信息
  return null;
}
