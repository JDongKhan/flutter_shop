import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '/utils/asset_bundle_utils.dart';
import '../../../widgets/custom_bouncing_scroll_physics.dart';
import '../../detail/page/shop_detail_page.dart';
import '../../model/shop_info.dart';

/// @author jd
class ShopHomeProductListPage extends StatefulWidget {
  const ShopHomeProductListPage(
      {Key? key, this.keyword, this.parsentController})
      : super(key: key);
  final String? keyword;
  final ScrollController? parsentController;
  @override
  State createState() => _ShopHomeProductListPageState();
}

class _ShopHomeProductListPageState extends State<ShopHomeProductListPage>
    with AutomaticKeepAliveClientMixin {
  final List<ShopInfo> _recommendList = [];
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() {
    _recommendList.addAll([
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_0'),
        shopName: '洗发水-你值得拥有',
        price: 18.80,
      ),
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_1'),
        shopName: '蛋糕-好吃到爆',
        price: 8.80,
      ),
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_2'),
        shopName: '潘婷染烫修护润发精华素750ml修复烫染损伤受损干枯发质',
        price: 48.80,
      ),
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_3'),
        shopName: '潘婷染烫修护润发精华素750ml修复烫染损伤受损干枯发质',
        price: 48.80,
      ),
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_4'),
        shopName: '潘婷染烫修护润发精华素750ml修复烫染损伤受损干枯发质',
        price: 48.80,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: _refreshWidget(
        child: WaterfallFlow.builder(
          itemCount: _recommendList.length * 2,
          gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
            collectGarbage: (List<int> garbages) {
              print('garbages:$garbages');
            },
            viewportBuilder: (int firstIndex, int lastIndex) {
              print('viewport:[$firstIndex, $lastIndex]');
            },
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            lastChildLayoutTypeBuilder: (int index) =>
                index == _recommendList.length * 2
                    ? LastChildLayoutType.foot
                    : LastChildLayoutType.none,
          ),
          physics: const CustomBouncingScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (BuildContext context, int index) {
            return _buildProductItem(index);
          },
        ),
      ),
    );
  }

  Widget _refreshWidget({required Widget child}) {
    const bool refreshEnable = true;
    if (refreshEnable) {
      return child;
    }
    return child;
  }

  void _onLoading() {
    // _refreshController.refreshCompleted();
    _addMoreData();
  }

  Widget _buildProductItem(int index) {
    ShopInfo shopInfo = _recommendList[index % _recommendList.length];
    return InkWell(
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
            Container(
              margin: const EdgeInsets.all(10),
              child: Image.asset(
                AssetBundleUtils.getImgPath('shop_${index % 5}'),
                height: index == 0 ? 100 : 120,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  '每一个商品都有灵魂-$index',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 14,
                    // fontWeight: FontWeight.bold,
                  ),
                )),
            Container(
                margin: const EdgeInsets.only(
                  left: 10,
                ),
                child: const Text(
                  '￥100',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _addMoreData() {
    _recommendList.addAll([
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_0'),
        shopName: '洗发水-你值得拥有',
        price: 18.80,
      ),
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_1'),
        shopName: '蛋糕-好吃到爆',
        price: 8.80,
      ),
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_2'),
        shopName: '潘婷染烫修护润发精华素750ml修复烫染损伤受损干枯发质',
        price: 48.80,
      ),
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_3'),
        shopName: '潘婷染烫修护润发精华素750ml修复烫染损伤受损干枯发质',
        price: 48.80,
      ),
      ShopInfo(
        icon: AssetBundleUtils.getImgPath('shop_4'),
        shopName: '潘婷染烫修护润发精华素750ml修复烫染损伤受损干枯发质',
        price: 48.80,
      ),
    ]);
    setState(() {});
  }

  @override
  void deactivate() {
    print('deactivate');
    super.deactivate();
  }

  @override
  void didUpdateWidget(covariant ShopHomeProductListPage oldWidget) {
    print('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;
}
