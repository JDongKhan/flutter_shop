import '../environment.dart';
import 'services.dart';

/// @author jd

class ServicesPath {
  ServicesPath(Environment environment) {
    if (environment == Environment.prd) {
      services = ServicesPrd();
    }
    if (environment == Environment.sit) {
      services = ServicesSit();
    }
    if (environment == Environment.pre) {
      services = ServicesPre();
    }
  }
  late Services services;

  String get homeInfo => '${services.baseUrl}/app/home/home.do';

  ///订单查询接口
  String get orderQueryUrl => '${services.baseUrl}/app/order_query.do';

  //分类列表
  String get categoryList => '${services.baseUrl}/app/category/category_list';
}
