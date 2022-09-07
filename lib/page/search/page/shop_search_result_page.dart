import 'package:flutter/material.dart';

import '/utils/asset_bundle_utils.dart';
import '../../../widgets/direction_button.dart';
import '../../../widgets/search_bar.dart';
import '../../detail/page/shop_detail_page.dart';
import '../../model/shop_info.dart';
import '../widget/shop_search_filter_widget.dart';

/// @author jd
class ShopSearchResultPage extends StatefulWidget {
  const ShopSearchResultPage({Key? key, this.query}) : super(key: key);
  final String? query;

  @override
  State createState() => _ShopSearchResultPageState();
}

class _ShopSearchResultPageState extends State<ShopSearchResultPage> {
  List<ShopInfo> list = [];

  bool showGrid = false;

  @override
  void initState() {
    list = List.generate(
      50,
      (index) => ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_${index % 5}'),
        shopName: '潘婷染烫修护润发精华素750ml修复烫染损伤受损干枯发质',
        price: 48.80,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: ShopSearchFilterWidget(),
      ),
      appBar: AppBar(
        elevation: 1,
        title: _buildSearch(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.category),
              onPressed: () {
                setState(() {
                  showGrid = !showGrid;
                });
              })
        ],
      ),
      body: Column(
        children: [
          _buildCondition(),
          if (showGrid)
            Expanded(child: _buildGridWidget())
          else
            Expanded(child: _buildListWidget()),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return SearchBar();
  }

  Widget _buildCondition() {
    return Container(
      height: 40,
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Row(
        children: [
          const Text('综合'),
          const SizedBox(
            width: 10,
          ),
          const DirectionButton(
            icon: Icon(Icons.sort),
            text: Text('价格'),
            imageDirection: AxisDirection.right,
            backgroundColor: Colors.transparent,
          ),
          Expanded(child: Container()),
          Builder(
            builder: (BuildContext context) {
              return DirectionButton(
                action: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.filter_list),
                text: const Text('筛选'),
                imageDirection: AxisDirection.right,
                backgroundColor: Colors.transparent,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListWidget() {
    return ListView.separated(
        itemBuilder: (BuildContext c, int idx) {
          ShopInfo shopInfo = list[idx];
          return _buildListItem(shopInfo);
        },
        separatorBuilder: (BuildContext c, int idx) {
          return const Divider(
            height: 1,
          );
        },
        itemCount: list.length);
  }

  Widget _buildListItem(ShopInfo shopInfo) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _pushNext(shopInfo);
      },
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(10),
            child: Image.asset(shopInfo.icon ?? ''),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shopInfo.shopName ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(shopInfo.price.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridWidget() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //每行三列
            mainAxisSpacing: 15,
            childAspectRatio: 1.0 //显示区域宽高相等
            ),
        itemBuilder: (c, idx) {
          ShopInfo shopInfo = list[idx];
          return _buildGirdItem(shopInfo);
        },
      ),
    );
  }

  Widget _buildGirdItem(ShopInfo shopInfo) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _pushNext(shopInfo);
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(
          left: 5,
          right: 5,
        ),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.asset(shopInfo.icon ?? ''),
                ),
              ),
            ),
            Text(
              shopInfo.shopName ?? '',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(shopInfo.price.toString()),
          ],
        ),
      ),
    );
  }

  void _pushNext(ShopInfo shopInfo) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ShopDetailPage(shopInfo);
    }));
  }
}
