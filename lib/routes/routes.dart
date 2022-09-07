import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/page/login/login_page.dart';

import '/page/splash/splash_page.dart';
import '../page/error/not_find_page.dart';

final Map<String, WidgetBuilder> _routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => SplashPage(),
  '/login': (BuildContext context) => const LoginPage(),
};

Map<String, WidgetBuilder> get routes => _routes;

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final WidgetBuilder? builder = routes[settings.name];
    return CupertinoPageRoute<dynamic>(
      builder: builder ?? (BuildContext context) => NotFindPage(),
    );
  }
}
