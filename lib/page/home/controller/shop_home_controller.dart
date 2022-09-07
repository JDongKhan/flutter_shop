import '/utils/asset_bundle_utils.dart';
import '../../../base/base_common_controller.dart';
import '../../../network/network_utils.dart';
import '../../../service/environment.dart';
import '../../model/shop_info.dart';

/// @author jd

class ShopHomeController extends BaseCommonController {
  String? searchText;
  List banners = [];
  List tabs = [];
  List<ShopInfo> recommends = <ShopInfo>[];

  Future<bool> onRefresh() async {
    print('开始刷新了');
    // _globalKey.currentState.show(notificationDragOffset: 200);
    await loadData();
    return true;
  }

  @override
  Future loadData() async {
    final NetworkResponse response =
        await Network.get(environments.servicesPath.homeInfo, mock: true);
    Map data = response.data;
    List recommendList = data['recommends'];
    List tabList = data['tabs'];
    banners = data['banners'];
    recommends = recommendList
        .map(
          (e) => ShopInfo(
            icon: AssetBundleUtils.getImgPath(e['icon']),
            shopName: e['name'],
            price: e['price'],
          ),
        )
        .toList();
    tabs = tabList;
    return data;
  }
}
