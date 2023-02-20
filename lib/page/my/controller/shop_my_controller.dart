import 'package:flutter_core/flutter_core.dart';

import '/base/base_common_controller.dart';
import '../../../service/environment.dart';

/// @author jd

class ShopMyController extends BaseCommonController {
  List headMenu = [];
  List orderMenu = [];
  List gridMenu = [];

  @override
  Future loadData() async {
    final NetworkResponse response =
        await Network.get(environments.servicesPath.userInfo, mock: true);
    Map data = response.data;
    headMenu = data['headMenu'];
    orderMenu = data['orderMenu'];
    gridMenu = data['gridMenu'];

    return data;
  }

  @override
  void onCompleted(data) {}
}
