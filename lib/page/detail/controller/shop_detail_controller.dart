import '/base/base_common_controller.dart';
import '../../../network/network_utils.dart';

/// @author jd

class ShopDetailController extends BaseCommonController {
  @override
  Future loadData() async {
    NetworkResponse response =
        await Network.get('http://baidu.com/message_list.do', mock: true);
    List list = response.data;
    return list;
  }

  @override
  void onCompleted(data) {}
}