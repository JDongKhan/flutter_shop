import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/page/login/page/login_home_page.dart';
import 'package:get/get.dart';
import '../service/environment.dart';

///@Description TODO
///@Author jd
class UserInfoController extends ChangeNotifier {
  final RxBool _loginFlag = false.obs;
  bool get isLogin => _loginFlag.value;
  Map? userInfo;

  //尝试打开登录页面
  static Future testLogin(BuildContext context) async {
    UserInfoController controller = Get.find<UserInfoController>();
    if (controller.isLogin) {
      return null;
    }
    return showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext c) => const LoginHomePage(),
    );
  }

  Future login() async {
    final NetworkResponse response =
        await Network.get(environments.servicesPath.loginUrl, mock: true);
    userInfo = response.data;
    _loginFlag.value = true;
    //清理cookie
    CookiesManager.getInstance().deleteAll();
    return userInfo!;
  }

  void logout() {
    _loginFlag.value = false;
  }
}
