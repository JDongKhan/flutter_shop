import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/base/base_refresh_list_controller.dart';
import 'package:flutter_shop/service/environment.dart';

import '../model/order_info.dart';

/// @author jd

class OrderListController extends BaseRefreshListController<OrderInfo> {
  String tag;
  OrderListController(this.tag);
  @override
  Future loadData() async {
    final NetworkResponse response =
        await Network.get(environments.servicesPath.orderList, mock: true);
    List ls = response.data;
    List<OrderInfo> list = ls.map((e) => OrderInfo.fromJson(e)).toList();
    return list;
  }
}
