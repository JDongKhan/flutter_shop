import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/controller/theme_controller.dart';
import 'package:flutter_shop/controller/user_info_controller.dart';
import 'package:flutter_shop/utils/navigation_util.dart';
import 'package:get/get.dart';

import 'routes/routes.dart';

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
  ThemeController themeController = Get.put(ThemeController());
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
    debugPaintSizeEnabled = themeController.debugPaintSizeEnabled; //显示边界布局
    debugPaintPointersEnabled =
        themeController.debugPaintPointersEnabled; //点击效果
    debugPaintLayerBordersEnabled =
        themeController.debugPaintLayerBordersEnabled; //显示边界
    debugRepaintRainbowEnabled =
        themeController.debugRepaintRainbowEnabled; //重绘时周边显示旋转色
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            checkerboardRasterCacheImages:
                themeController.checkerboardRasterCacheImages,
            checkerboardOffscreenLayers:
                themeController.checkerboardOffscreenLayers,
            navigatorKey: NavigationUtil.getInstance().navigatorKey,
            theme: ThemeData(
              //深色还是浅色
              brightness: Brightness.light,
              //text button样式
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Colors.black87,
                ),
              ),
              tabBarTheme: TabBarTheme.of(context).copyWith(
                labelColor: Colors.black,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: Colors.blue),
                ),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                elevation: 0,
                centerTitle: true,
                toolbarTextStyle: TextStyle(
                  color: Colors.red,
                ),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            initialRoute: "/",
            onGenerateRoute: Routers.generateRoute,
          );
        });
  }
}
