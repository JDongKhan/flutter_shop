import '/utils/asset_bundle_utils.dart';
import '../../../../base/base_refresh_list_controller.dart';
import '../../../model/carI_item.dart';
import '../../../model/shop_info.dart';

/// @author jd

class ShopCarViewModel extends BaseRefreshListController<CarItem> {
  // 禁止改变购物车里的商品信息
//  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  //选中列表
  List<CarItem> get checkedList =>
      data.where((element) => element.checked).toList();

  //购物车中商品的总价
  double get totalPrice => checkedList.fold(
      0, (value, item) => value + item.count * (item.shopInfo.price ?? 0));

  //是否全部选中
  bool get allChecked => data.every((element) => element.checked);

  void checkItem(CarItem item, bool checked) {
    item.checked = checked;
    update();
  }

  @override
  Future<List<CarItem>> loadData({int pageNum = 0}) async {
    List<CarItem> list = [
      CarItem(
          ShopInfo(
            icon: AssetBundleUtils.getImgPath('defalut_product'),
            shopName: '潘婷染烫修护润发精华素750ml修复烫染损伤受损干枯发质',
            price: 48.80,
          ),
          1),
    ];
    return list;
  }
}
