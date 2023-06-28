import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/page/activity/activity_page.dart';
import 'package:flutter_shop/page/order/order_list/page/order_list_page.dart';
import 'package:flutter_shop/widgets/webview/web_page.dart';
import 'package:go_router/go_router.dart';

import 'page/login/page/login_page.dart';
import 'page/my/page/member_home_page.dart';
import 'page/setting/developer/developer_setting_page.dart';
import 'page/setting/feedback/feedback_page.dart';
import 'page/setting/message_setting_page.dart';
import 'page/setting/privacy_setting_page.dart';
import 'page/setting/setting_page.dart';
import 'page/shop_main_page.dart';
import 'page/splash/splash_page.dart';

// import 'pages/dashboard/page/dashboard.dart' deferred as home;

/// @author jd
final routes = GoRouter(
  initialLocation: "/splash",
  debugLogDiagnostics: true,
  observers: [
    ToastUtils.observer(),
  ],
  //重定向
  // redirect: (BuildContext context, GoRouterState state) {
  //   if (!LoginUtil.isLoggedIn) {
  //     return '/login';
  //   } else {
  //     return null;
  //   }
  // },
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => ChangeNotifierProvider(
    //     create: (BuildContext context) => DashboardModel(),
    //     child: DeferredWidget(
    //       future: home.loadLibrary(),
    //       builder: () => home.DashboardPage(),
    //     ),
    //   ),
    // ),
    GoRoute(path: '/splash', builder: (context, state) => SplashPage()),
    GoRoute(path: '/', builder: (context, state) => const ShopMainPage()),
    GoRoute(
        path: '/activity', builder: (context, state) => const ActivityPage()),
    GoRoute(
        path: '/order_list',
        builder: (context, state) => const OrderListPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
        path: '/member_home', builder: (context, state) => MemberHomePage()),
    GoRoute(path: '/setting', builder: (context, state) => const SettingPage()),
    GoRoute(
        path: '/message_setting',
        builder: (context, state) => const MessageSettingPage()),
    GoRoute(
        path: '/privacy_setting',
        builder: (context, state) => const PrivacySettingPage()),
    GoRoute(
        path: '/feedback', builder: (context, state) => const FeedbackPage()),
    GoRoute(
        path: '/developer_setting',
        builder: (context, state) => const DeveloperSettingPage()),
    GoRoute(
        path: '/feedback', builder: (context, state) => const FeedbackPage()),
    GoRoute(
        path: '/privacy_setting',
        builder: (context, state) => const PrivacySettingPage()),
    GoRoute(
        path: '/message_setting',
        builder: (context, state) => const MessageSettingPage()),
    GoRoute(
      path: '/web',
      builder: (context, state) => WebPage(
        url: state.queryParameters['url'] ?? '',
        title: state.queryParameters['title'] ?? '',
      ),
    ),
  ],
);
