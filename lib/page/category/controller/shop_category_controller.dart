import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/base/base_list_controller.dart';

import '../../../service/environment.dart';
import '../model/category.dart';

/// @author jd

class ShopCategoryController extends BaseListController<Category> {
  @override
  Future<List<Category>> loadData() async {
    final NetworkResponse response =
        await Network.get(environments.servicesPath.categoryList, mock: true);
    List ls = response.data;
    List<Category> list = ls.map((e) => Category.fromJson(e)).toList();
    return list;
  }
}
