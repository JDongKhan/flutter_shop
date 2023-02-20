import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app.dart';
import 'interceptor/token_invalid_interceptor.dart';
import 'service/environment.dart';

void main() {
  ErrorWidget.builder = _defaultErrorWidgetBuilder;
  CrashUtils.collect(_runApp, () {
    //TODO 设置bugly的配置 https://pub.flutter-io.cn/packages/flutter_bugly
    //ios、android相关代码
    FlutterBugly.postCatchedException(() {
      _runApp();
      FlutterBugly.init(
        androidAppId: "ea45219d5a",
        iOSAppId: "04663371d6",
      );
    }, onException: (FlutterErrorDetails details) {
      //继续打印到控制台
      FlutterError.dumpErrorToConsole(details, forceReport: true);
    });
  });
}

//打印出错误信息
Widget _defaultErrorWidgetBuilder(FlutterErrorDetails details) {
  String message =
      '${details.exception}\nSee also: https://flutter.dev/docs/testing/errors';
  final Object exception = details.exception;
  return ErrorWidget.withDetails(
      message: message, error: exception is FlutterError ? exception : null);
}

void _runApp() {
  //可以从编译参数获取环境变量，用以更改
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  AppInfo.init(orientations: const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => {}).whenComplete(() {
    String env = SpUtils.getString("environment_config", defValue: "PRD");
    //初始化环境配置
    environments.init(env: env);
    //添加cookie
    //const ColorFilter.mode(Colors.grey, BlendMode.color),
    Network.addInterceptor(TokenInvalidInterceptor());
    //初始化第三方蓝牙sdk
    // FlutterIotSdk.init();
    runApp(const MyApp());
    FlutterNativeSplash.remove();
  });
}
