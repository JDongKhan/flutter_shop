import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/page/activity/activity_page.dart';
import 'package:get/get.dart';

import '../../../utils/navigation_util.dart';
import '../../setting/setting_page.dart';
import '../controller/shop_my_controller.dart';
import 'member_home_page.dart';

/// @author jd

class ShopMyPage extends StatefulWidget {
  const ShopMyPage({Key? key}) : super(key: key);

  @override
  _ShopMyPageState createState() => _ShopMyPageState();
}

class _ShopMyPageState extends State<ShopMyPage>
    with AutomaticKeepAliveClientMixin {
  final ShopMyController _shopMyController = Get.put(ShopMyController());
  int _appBarStyle = 0;
  bool _showToTopBtn = false; //是否显示“返回到顶部”按钮
  final ScrollController _controller = ScrollController();

  Map<String, IconData> iconsMap = {
    "memory": Icons.memory,
    "filter_center_focus": Icons.filter_center_focus,
    "border_horizontal": Icons.border_horizontal,
    "contact_phone": Icons.contact_phone,
    "payment": Icons.payment,
    "send": Icons.send,
    "receipt": Icons.receipt,
    "comment": Icons.comment,
    "backpack": Icons.backpack,
    "assignment": Icons.assignment,
    "contact_phone": Icons.contact_phone,
    "border_color": Icons.border_color,
    "help": Icons.help,
    "people": Icons.people,
    "color_lens": Icons.color_lens,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: NotificationListener(
          onNotification: (Notification scrollNotification) {
            if ((scrollNotification is ScrollUpdateNotification) &&
                (scrollNotification.depth == 0)) {
              _onScroll(scrollNotification.metrics.pixels);
            }
            return true;
          },
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.grey[200],
              ),
              GetBuilder<ShopMyController>(builder: (controller) {
                return _buildScrollWidget();
              }),
            ],
          )),
    );
  }

  Widget _buildScrollWidget() {
    return CustomScrollView(
      controller: _controller,
      slivers: <Widget>[
        //AppBar，包含一个导航栏
        if (_appBarStyle == 0) _buildStyle0AppBar() else _buildStyle1AppBar(),

        //订单菜单
        SliverPadding(
          padding: const EdgeInsets.only(top: 10),
          sliver: _buildOrderMenusWidget(),
        ),

        //功能菜单
        SliverPadding(
          padding: const EdgeInsets.only(top: 10),
          sliver: _buildFunctionMenuWidget(),
        ),

        //推荐商品title
        SliverPadding(
          padding: const EdgeInsets.only(top: 10),
          sliver: _buildRecommendTitleWidget(),
        ),
        //推荐商品列表
        _buildRecommendGridWidget(),
      ],
    );
  }

  //导航1
  Widget _buildStyle0AppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      centerTitle: true,
      leading: _buildLeading(),
      actions: _buildAction(),
      title: InkWell(
        onTap: () {
          setState(() {
            _appBarStyle = _appBarStyle == 0 ? 1 : 0;
          });
        },
        child: const Text(
          '我的',
          style: TextStyle(color: Colors.white),
        ),
      ),
      elevation: 2,
      pinned: true,
//      floating: true,
//      snap: true,
      //backgroundColor导致
//       backgroundColor: Colors.blue[100],
      flexibleSpace: FlexibleSpaceBar(
        //视差效果
        collapseMode: CollapseMode.parallax,
        background: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Image.asset(
              AssetBundleUtils.getImgPath('user_head'),
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            _buildMenusGridWidget(),
          ],
        ),
      ),
    );
  }

  //导航2
  Widget _buildStyle1AppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 250.0,
      leading: _buildLeading(),
      actions: _buildAction(),
      backgroundColor: Colors.blue[100],
      flexibleSpace: FlexibleSpaceBar(
        title: InkWell(
          onTap: () {
            setState(() {
              _appBarStyle = _appBarStyle == 0 ? 1 : 0;
            });
          },
          child: const Text(
            '我的',
            style: TextStyle(color: Colors.white),
          ),
        ),
        background: Image.asset(
          AssetBundleUtils.getImgPath('user_head'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //左边头像
  Widget _buildLeading() => Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                NavigationUtil.push("/member_home");
              },
              child: Image.asset(AssetBundleUtils.getImgPath('head')),
            ),
          ],
        ),
      );

  //右侧设置按钮
  List<Widget> _buildAction() => <Widget>[
        IconButton(
          icon: Icon(
            Icons.settings,
            color: _appBarStyle == 0 ? Colors.white : Colors.black12,
          ),
          onPressed: () {
            NavigationUtil.push("/setting");
          },
        )
      ];

  //顶部菜单
  Widget _buildMenusGridWidget() {
    double itemWidth = 80;
    int count = MediaQuery.of(context).size.width ~/ itemWidth;
    return SizedBox(
      height: 90,
      child: GridView.count(
        crossAxisCount: count,
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        children: _shopMyController.headMenu
            .map((e) => Container(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Tab(
                      icon: Icon(
                        iconsMap[e['icon']] as IconData,
                        color: Colors.white,
                      ),
                      child: Text(
                        e['title'].toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  //订单菜单
  Widget _buildOrderMenusWidget() {
    double itemWidth = 80;
    int count = MediaQuery.of(context).size.width ~/ itemWidth;
    return SliverToBoxAdapter(
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    '我的订单',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    child: GestureDetector(
                      child: Row(
                        children: const <Widget>[
                          Text('查看全部'),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            GridView.count(
              crossAxisCount: count,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(0),
              childAspectRatio: 1,
              shrinkWrap: true, //解决gridview不能在customScrollView显示的问题
              children: _shopMyController.orderMenu
                  .map((item) => _getItem(item))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  //常用功能
  Widget _buildFunctionMenuWidget() {
    double itemWidth = 80;
    int count = MediaQuery.of(context).size.width ~/ itemWidth;
    return SliverToBoxAdapter(
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    '常用功能',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),
            GridView.count(
              crossAxisCount: count,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.all(0),
              childAspectRatio: 1,
              shrinkWrap: true, //解决gridview不能在customScrollView显示的问题
              children: _shopMyController.gridMenu
                  .map((item) => _getItem(item))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  //常用功能item
  Widget _getItem(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        String? route = item['route'];
        if (route != null) {
          NavigationUtil.push(route);
        }
      },
      child: Tab(
        icon: Icon(iconsMap[item['icon']] as IconData),
        child: Text(
          item['title'].toString(),
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  //推荐商品title
  Widget _buildRecommendTitleWidget() {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 10),
        child: const Text(
          '--- 为您推荐-人气商品 ---',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //推荐商品列表
  Widget _buildRecommendGridWidget() {
    return SliverGrid(
      //Grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //Grid按两列显示
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建子widget
          return _buildProductItem(index);
        },
        childCount: 60,
      ),
    );
  }

  void _onScroll(double offset) {
    if (offset < 1000 && _showToTopBtn) {
      setState(() {
        _showToTopBtn = false;
      });
    } else if (offset >= 1000 && _showToTopBtn == false) {
      setState(() {
        _showToTopBtn = true;
      });
    }
  }

  //推荐列表 产品item
  Widget _buildProductItem(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Image.asset(
                  AssetBundleUtils.getImgPath('shop_${index % 5}'),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  top: 5,
                ),
                child: const Text(
                  '商品名称',
                  maxLines: 2,
                )),
            Container(
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                child: const Text('￥100')),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
