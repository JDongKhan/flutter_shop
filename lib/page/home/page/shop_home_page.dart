import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

import '../../../widgets/common_sliver_persistent_header_delegate.dart';
import '../../../widgets/my_search_delegate.dart';
import '../../../widgets/searchbar/search_bar.dart';
import '/controller/theme_controller.dart';
import '../../detail/page/shop_detail_page.dart';
import '../../model/shop_info.dart';
import '../../shop_main_page.dart';
import '../controller/shop_home_controller.dart';
import '../widget/list_bottom_menu.dart';
import '../widget/shop_home_appbar.dart';
import '../widget/shop_home_widget_config.dart';
import 'shop_home_product_list_page.dart';
import 'shop_home_product_list_page_1.dart';

/// @author jd

@Deprecated("废弃")
class ShopHomePage extends StatefulWidget {
  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ShopHomeController _controller = Get.put(ShopHomeController());
  TabController? _tabController;
  double _offset = 0;
  final ListBottomMenuController _bottomMenuController =
      ListBottomMenuController(animal: true);

  @override
  void initState() {
    _tabController =
        TabController(vsync: this, length: _controller.tabs.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeController themeController =
        ThemeNotifierProviderWidget.of<ThemeController>(context) ??
            ThemeController();
    return Stack(
      children: [
        //底部菜单
        ListBottomMenu(
          controller: _bottomMenuController,
          onBack: () {
            _showMainPage();
          },
        ),
        //上部分信息
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
          transform: Matrix4.translationValues(0.0, _offset, 0.0),
          child: _refreshWidget(
            child: GetBuilder<ShopHomeController>(builder: (controller) {
              _tabController =
                  TabController(vsync: this, length: controller.tabs.length);
              return _buildScrollWidget(controller, themeController);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollWidget(
      ShopHomeController controller, ThemeController themeController) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        List<Widget> headerSlivers = [];

        //下拉刷新
        headerSlivers.add(PullToRefreshContainer(
          (info) => buildPulltoRefreshImage(context, info),
        ));

        //导航
        headerSlivers.add(
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),

            ///SliverAppBar也可以实现吸附在顶部的TabBar，但是高度不好计算，总是会有AppBar的空白高度，
            sliver: ShopHomeAppBar(
              backgroundColor: themeController.navigationBackgroundColor,
              title: Text(
                '生产有限公司',
                style: TextStyle(
                  color: themeController.navigationTextColor,
                  fontSize: 18,
                ),
              ),
              centerTitle: false,
              expandedHeight: 140.0,
              brightness: Brightness.light,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: _buildSearch(context),
              ),
              // leading: const IconButton(
              //   icon: Icon(
              //     Icons.home,
              //     color: Colors.white,
              //   ),
              // ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.business,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );

        //空隙
        headerSlivers.add(
          const SliverToBoxAdapter(
            child: SafeArea(
              child: SizedBox(
                height: 50,
              ),
            ),
          ),
        );

        //轮播图
        if (controller.banners.isNotEmpty) {
          headerSlivers.add(SliverToBoxAdapter(child: _buildSwiper()));
        }
        //菜单
        if (controller.recommends.isNotEmpty) {
          headerSlivers.add(SliverToBoxAdapter(child: _buildGridView()));
        }

        if (controller.tabs.isNotEmpty) {
          //tab菜单
          headerSlivers.add(_buildPersistentHeader());
        }
        return headerSlivers;
      },
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: controller.tabs
            .map(
              (e) => _buildContentPage(e),
            )
            .toList(),
      ),
    );
  }

  //tab下的页面
  Widget _buildContentPage(Map e) {
    final int index = _controller.tabs.indexOf(e);
    if (index == 1) {
      return ShopHomeProductListPage1(
        keyword: e['title'].toString(),
      );
    }
    return ShopHomeProductListPage(
      keyword: e['title'].toString(),
    );
  }

  //隐藏底部导航
  void hiddenBottomBar(bool hidden) {
    ShopMainPage.of(context)?.hiddenBottomNavigationBar(hidden);
  }

  //显示主页面
  void _showMainPage() {
    hiddenBottomBar(false);
    setState(() {
      _offset = 0;
      _bottomMenuController.opacity = 0;
    });
  }

  Future<bool> _onRefresh() async {
    print('开始刷新了');
    // _globalKey.currentState.show(notificationDragOffset: 200);
    await _controller.onRefresh();
    setState(() {
      _offset = getScreenHeight();
      _bottomMenuController.opacity = 1;
      hiddenBottomBar(true);
    });
    return true;
  }

  ///刷新
  Widget _refreshWidget({required Widget child}) {
    const bool refreshEnable = true;
    if (refreshEnable) {
      return PullToRefreshNotification(
        color: Theme.of(context).canvasColor,
        // pullBackOnRefresh: true,
        onRefresh: _onRefresh,
        armedDragUpCancel: false,
        maxDragOffset: 200,
        child: child,
      );
    }
    return child;
  }

  ///Search
  Widget _buildSearch(BuildContext context) {
    return Container(
      // color: Colors.red,
      // height: 60,
      margin: const EdgeInsets.only(bottom: 10),
      child: SearchBar(
        text: _controller.searchText,
        onTap: () {
          showSearch(context: context, delegate: MySearchDelegate());
          // showCustomSearch(
          //   context: context,
          //   builder: (context, constraints, query) {
          //     logger.i('开始查询数据:$query');
          //     if (query.isBlank!) {
          //       return RecommendTagsWidget();
          //     }
          //     return SearchTagList(
          //       query: query,
          //     );
          //   },
          // );
        },
      ),
    );
  }

  ///Swiper
  Widget _buildSwiper() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: Swiper(
        itemCount: _controller.banners.length,
        autoplay: true,
        pagination: const SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                activeColor: Colors.red, color: Colors.green)),
        itemBuilder: (BuildContext context, int index) {
          return Image.asset(
            AssetBundleUtils.getImgPath(_controller.banners[index]['image']),
            fit: BoxFit.fill,
          );
        },
      ),
    );
  }

  ///GridView
  Widget _buildGridView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 10,
            left: 10,
            bottom: 10,
          ),
          child: const Text(
            '常购清单',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        SizedBox(
          height: 180,
          child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, //每行三列
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.4 //显示区域宽高相等
                  ),
              itemCount: _controller.recommends.length,
              itemBuilder: (context, index) {
                ShopInfo shopInfo = _controller.recommends[index];
                //如果显示到最后一个并且Icon总数小于200时继续获取数据
                return _buildGirdItem(shopInfo);
              }),
        ),
      ],
    );
  }

  ///GridItem
  Widget _buildGirdItem(ShopInfo shopInfo) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ShopDetailPage(shopInfo);
        }));
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                // color: Colors.red,
                alignment: Alignment.center,
                child: Image.asset(
                  shopInfo.icon ?? '',
                  // fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 5,
                ),
                child: Text(
                  shopInfo.shopName ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 5,
                ),
                child: Text('￥${shopInfo.price}')),
          ],
        ),
      ),
    );
  }

  ///tabbar
  Widget _buildPersistentHeader() => SliverPersistentHeader(
        pinned: true,
        delegate: CommonSliverPersistentHeaderDelegate(
            40,
            60,
            Container(
              color: Colors.grey[100],
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                // These are the widgets to put in each tab in the tab bar.
                tabs: _controller.tabs
                    .map<Tab>((dynamic map) => Tab(text: map['name']))
                    .toList(),
              ),
            )),
      );

  @override
  bool get wantKeepAlive => true;
}
