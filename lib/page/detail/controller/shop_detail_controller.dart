import 'package:flutter_core/flutter_core.dart';

import '/base/base_common_controller.dart';

/// @author jd

class ShopDetailController extends BaseCommonController {
  @override
  Future loadData() async {
    NetworkResponse response =
        await Network.get('http://baidu.com/detail.do', mock: true);
    List list = response.data;
    return list;
  }
}
