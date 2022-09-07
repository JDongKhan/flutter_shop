import 'services_path.dart';

/// @author jd

extension ShopService on ServicesPath {
  //首页信息
  String get homeInfo => '${services.baseUrl}/app/home.do';

  //分类列表
  String get categoryList => '${services.baseUrl}/app/category/category_list';
}
