import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_shop/route.dart';
import 'package:get/get.dart';
import 'base/config.dart';
import 'controller/theme_controller.dart';
import 'controller/user_info_controller.dart';

///@Description TODO
///@Author jd
/*
 * flutter 相对布局
 * 一、Stack和Align配合
 * 二、Row和mainAxisAlignment.spaceBetween
 *
 * flutter 绝对布局
 * 1、Stack和Positioned配合
 */
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserInfoController userInfo = Get.put(UserInfoController());

  @override
  void initState() {
    super.initState();
    //缓存个数 100
    PaintingBinding.instance.imageCache.maximumSize = 100;
    //缓存大小 50m
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeNotifierProviderWidget(
      data: ThemeController(),
      builder: <ThemeController>(c, controller) {
        return buildApp(controller);
      },
    );
  }

  Widget buildApp(ThemeController themeController) {
    debugPaintSizeEnabled = themeController.debugPaintSizeEnabled; //显示边界布局
    debugPaintPointersEnabled =
        themeController.debugPaintPointersEnabled; //点击效果
    debugPaintLayerBordersEnabled =
        themeController.debugPaintLayerBordersEnabled; //显示边界
    debugRepaintRainbowEnabled =
        themeController.debugRepaintRainbowEnabled; //重绘时周边显示旋转色
    //https://www.jianshu.com/p/95b71efe69f4
    //https://blog.csdn.net/weixin_52262025/article/details/123561960
    return MaterialApp.router(
      title: kAppName,
      showPerformanceOverlay: themeController.showPerformanceOverlay,
      checkerboardRasterCacheImages:
          themeController.checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: themeController.checkerboardOffscreenLayers,
      routerConfig: routes,
      builder: ToastUtils.init(builder: (BuildContext context, Widget? child) {
        AppInfo.setup(context);
        //设置字体大小不随系统设置改变
        return child!;
      }),
      locale: const Locale('zh', 'CN'),
      supportedLocales: const <Locale>[
        Locale('en', 'US'), // 美国英语
        Locale('zh', 'CN'),
      ], // 中文简体],
      localizationsDelegates: const [
        // 本地化的代理类
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        ////应用程序主要部分（工具栏、标签栏等）的背景颜色
        primaryColor: Colors.black87,
        //调整亮度 白天模式和夜间模式 深色还是浅色
        brightness: Brightness.light,
        //用于自定义 [textButton] 外观和布局的主题
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black87,
          ),
        ),
        //用于自定义 [Checkbox][Radio] 小部件的外观和布局的主题
        toggleableActiveColor: Colors.blue,
        unselectedWidgetColor: Colors.blue,
        // checkboxTheme: CheckboxTheme.of(context).copyWith(
        //     // fillColor: const MaterialStatePropertyAll(Colors.blue),
        //     // checkColor: const MaterialStatePropertyAll(Colors.blue),
        //     ),
        //页面背景颜色
        scaffoldBackgroundColor: const Color(0xffeeeeee),
        //  [Divider]s和[PopupMenuDivider]的颜色，使用[ListTile] 之间，
        //  [DataTable]中的行之间，等等
        dividerTheme: DividerTheme.of(context).copyWith(
          color: const Color(0xffeeeeee),
          thickness: 1,
        ),
        //全局样式
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFD6D6D6),
              width: 1,
            ),
          ),
        ),
        tabBarTheme: TabBarTheme.of(context).copyWith(
          labelColor: Colors.black,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0, color: Colors.blue),
          ),
        ),
        switchTheme: SwitchTheme.of(context).copyWith(
          thumbColor: const MaterialStatePropertyAll(Colors.lightBlue),
          trackColor: MaterialStatePropertyAll(Colors.grey[400]),
        ),
        appBarTheme: AppBarTheme(
          //状态栏颜色
          systemOverlayStyle: SystemUiOverlayStyle.light,
          backgroundColor: themeController.navigationBackgroundColor,
          centerTitle: true,
          iconTheme: IconTheme.of(context)
              .copyWith(color: themeController.navigationTextColor),
          actionsIconTheme: IconTheme.of(context)
              .copyWith(color: themeController.navigationTextColor),
          toolbarTextStyle: TextStyle(
            color: themeController.navigationTextColor,
          ),
          titleTextStyle: TextStyle(
            color: themeController.navigationTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
