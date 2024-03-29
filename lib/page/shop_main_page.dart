import 'package:badges/badges.dart' as BAD;
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

import 'cart/cart_1/page/shop_car_page.dart';
import 'category/page/shop_category_page.dart';
import 'home/page/shop_home_page.dart';
import 'my/page/shop_my_page.dart';

/// @author jd

class ShopMainPage extends StatefulWidget {
  const ShopMainPage({Key? key}) : super(key: key);

  static _ShopMainPageState? of(BuildContext context) {
    return context.findAncestorStateOfType<_ShopMainPageState>();
  }

  @override
  _ShopMainPageState createState() => _ShopMainPageState();
}

class _ShopMainPageState extends State<ShopMainPage>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _tabs = <Map<String, dynamic>>[];
  TabController? _tabController;
  int _selectedIndex = 0;
  bool _hiddenBottomBar = false;
  @override
  void initState() {
    //初始化工具
    //initScreenUtil(context);
    _tabs.add({
      'title': '首页',
      'icon': Icons.home,
      'page': const ShopHomePage(),
    });

    _tabs.add({
      'title': '分类',
      'icon': Icons.business,
      'page': ShopCategoryPage(),
    });

    _tabs.add({
      'title': '购物车',
      'icon': Icons.camera,
      'count': 99,
      'page': const ShopCarPage(),
    });

    _tabs.add({
      'title': '我的',
      'icon': Icons.account_circle,
      'page': const ShopMyPage(),
    });

    _tabController = TabController(length: _tabs.length, vsync: this);

    super.initState();
  }

  void hiddenBottomNavigationBar(bool hidden) {
    setState(() {
      _hiddenBottomBar = hidden;
    });
  }

  void toCar(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    setState(() {
      switchTabbarIndex(2);
    });
  }

  DateTime? popTime;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (popTime == null ||
            DateTime.now().difference(popTime!) > const Duration(seconds: 1)) {
          popTime = DateTime.now();
          //进行拦截,给个提示,如果再次按的话,执行下面的操作;
          ToastUtils.toast('再次点击退出app');
          return Future.value(false);
        } else {
          popTime = DateTime.now();
          // 退出app
          return Future.value(true);
        }
      },
      child: Navigator(
        onPopPage: (route, result) => route.didPop(result),
        pages: [
          MaterialPage(child: _firstPage()),
        ],
      ),
    );
  }

  Widget _firstPage() {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _tabs.map((e) {
          return e['page'] as Widget;
        }).toList(),
      ),
      bottomNavigationBar: _hiddenBottomBar
          ? null
          : BottomNavigationBar(
              // 底部导航
              items: _tabs.map(
                (e) {
                  dynamic count = e['count'];
                  if (count != null) {
                    return BottomNavigationBarItem(
                      icon: BAD.Badge(
                        position:
                            BAD.BadgePosition.custom(start: 15, bottom: 10),
                        badgeContent: Text(
                          '$count',
                          style:
                              const TextStyle(color: Colors.white, fontSize: 9),
                        ),
                        child: Icon(e['icon'] as IconData),
                      ),
                      label: e['title'].toString(),
                    );
                  }
                  return BottomNavigationBarItem(
                    icon: Icon(e['icon'] as IconData),
                    label: e['title'].toString(),
                  );
                },
              ).toList(),
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.red,
              onTap: _onItemTapped,
            ),
    );
  }

  void _onItemTapped(int index) {
    switchTabbarIndex(index);
  }

  void switchTabbarIndex(int selectedIndex) {
    _tabController?.index = selectedIndex;
    setState(() {
      _selectedIndex = selectedIndex;
    });
  }
}
