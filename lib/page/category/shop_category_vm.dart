import 'package:get/get.dart';

import '../../network/network_utils.dart';
import '../../service/environment.dart';
import 'model/category.dart';

/// @author jd

class ShopCategoryVM extends GetxController {
  var list = <Category>[].obs;

  @override
  void onReady() {
    loadData();
  }

  Future loadData() async {
    final NetworkResponse response =
        await Network.get(environments.servicesPath.categoryList, mock: true);
    List ls = response.data;
    list.value = ls.map((e) => Category.fromJson(e)).toList();
    return list;
  }
}
