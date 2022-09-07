import '/base/base_common_controller.dart';
import '../../../network/network_utils.dart';

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
