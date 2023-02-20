import 'services_path.dart';

/// @author jd

extension OrderService on ServicesPath {
  //订单列表
  String get orderList => '${services.baseUrl}/app/order/order_list';
}
