import 'package:flutter/material.dart';
import 'package:flutter_shop/network/cookie_manager.dart';
import 'package:get/get.dart';

import '../network/network_utils.dart';
import '../service/environment.dart';

///@Description TODO
///@Author jd
class UserInfoController extends ChangeNotifier {
  final RxBool _loginFlag = false.obs;
  bool get isLogin => _loginFlag.value;
  Map? userInfo;

  void login() async {
    final NetworkResponse response =
        await Network.get(environments.servicesPath.loginUrl, mock: true);
    userInfo = response.data;
    _loginFlag.value = true;
    //清理cookie
    CookiesManager.getInstance().deleteAll();
  }

  void logout() {
    _loginFlag.value = false;
  }
}
