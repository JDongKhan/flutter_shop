import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/page/home/controller/shop_home_controller.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

import '../../../widgets/my_search_delegate.dart';
import '../../../widgets/searchbar/search_bar.dart' as SB;
import '../../detail/page/shop_detail_page.dart';
import '../../model/shop_info.dart';
import '../../shop_main_page.dart';
import '../widget/list_bottom_menu.dart';
import '../widget/shop_home_appbar.dart';
import '../widget/shop_home_widget_config.dart';
import 'shop_secondary_tabView_page.dart';
import 'shop_home_product_list_page.dart';
import 'shop_home_product_list_page_1.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({Key? key}) : super(key: key);

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final ShopHomeController _controller = Get.put(ShopHomeController());
  final ListBottomMenuController _bottomMenuController =
      ListBottomMenuController(animal: true);
  double _offset = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              return _buildScrollWidget(controller);
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildScrollWidget(ShopHomeController controller) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double pinnedHeaderHeight =
        //statusBar height
        statusBarHeight +
            //pinned SliverAppBar height in header
            kToolbarHeight;
    return DefaultTabController(
      length: controller.tabs.length,
      child: ExtendedNestedScrollView(
        headerSliverBuilder: (BuildContext c, bool f) {
          return buildSliverHeader(controller);
        },
        //1.[pinned sliver header issue](https://github.com/flutter/flutter/issues/22393)
        pinnedHeaderSliverHeightBuilder: () {
          return pinnedHeaderHeight;
        },
        //2.[inner scrollables in tabview sync issue](https://github.com/flutter/flutter/issues/21868)
        onlyOneScrollInBody: true,
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: TabBar(
                labelColor: Colors.blue,
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2.0,
                isScrollable: true,
                unselectedLabelColor: Colors.grey,
                tabs: _controller.tabs
                    .map<Tab>((dynamic map) => Tab(text: map['name']))
                    .toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                children:
                    controller.tabs.map<Widget>((e) => _buildPage(e)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map e) {
    final int index = _controller.tabs.indexOf(e);
    String title = e['name'].toString();
    if (index == 0) {
      return ShopHomeProductListPage1(
        keyword: title,
      );
    }
    if (index == 1) {
      return ShopSecondaryTabViewPage(
        title,
        e,
      );
    }
    if (index == 2) {
      return GlowNotificationWidget(
        ExtendedVisibilityDetector(
          uniqueKey: Key(title),
          child: ListView.builder(
            //store Page state
            key: PageStorageKey<String>(title),
            physics: const ClampingScrollPhysics(),
            itemCount: 50,
            itemBuilder: (BuildContext c, int i) {
              return Container(
                alignment: Alignment.center,
                height: 60.0,
                child: Text(
                  '${Key(title)}: ListView$i',
                ),
              );
            },
          ),
        ),
        showGlowLeading: false,
      );
    }
    return ShopHomeProductListPage(
      keyword: title,
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
      child: SB.SearchBar(
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
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
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
                    mainAxisSpacing: 10,
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
      ),
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

  List<Widget> buildSliverHeader(ShopHomeController controller) {
    List<Widget> headerSlivers = [];
    //下拉刷新
    headerSlivers.add(PullToRefreshContainer(
      (info) => buildPulltoRefreshImage(context, info),
    ));
    //导航
    headerSlivers.add(
      ShopHomeAppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          '生产有限公司',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: false,
        expandedHeight: 140.0,
        brightness: Brightness.light,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildSearch(context),
        ),
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
    );
    //
    //轮播图
    if (controller.banners.isNotEmpty) {
      headerSlivers.add(SliverToBoxAdapter(child: _buildSwiper()));
    }
    //菜单
    if (controller.recommends.isNotEmpty) {
      headerSlivers.add(SliverToBoxAdapter(child: _buildGridView()));
    }

    return headerSlivers;
  }

  @override
  bool get wantKeepAlive => true;
}
