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

  //首页信息
  String get homeInfo => '${services.baseUrl}/app/home.do';

  //用户信息
  String get userInfo => '${services.baseUrl}/app/user.do';

  //分类列表
  String get categoryList => '${services.baseUrl}/app/category/category_list';
}
