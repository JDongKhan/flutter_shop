import 'package:flutter_shop/utils/asset_bundle_utils.dart';
import 'package:get/get.dart';

import '../../../network/network_utils.dart';
import '../../../service/environment.dart';
import '../../model/shop_info.dart';

/// @author jd

class ShopHomeVM extends GetxController {
  String? searchText;

  var tabs = <Map<String, dynamic>>[].obs;

  final List<ShopInfo> recommendList = [
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
  ];

  Future<bool> onRefresh() async {
    print('开始刷新了');
    // _globalKey.currentState.show(notificationDragOffset: 200);
    await loadData();
    return true;
  }

  Future loadData() async {
    final NetworkResponse response =
        await Network.get(environments.servicesPath.categoryList, mock: true);
    List list = response.data;
    tabs.value = list
        .map((e) => {
              'title': e['name'],
            })
        .toList();
    return list;
  }
}
