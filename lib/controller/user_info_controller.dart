import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@Description TODO
///@Author jd
class UserInfoController extends ChangeNotifier {
  final RxBool _loginFlag = false.obs;
  bool get isLogin => _loginFlag.value;

  void login() {
    _loginFlag.value = true;
  }

  void logout() {
    _loginFlag.value = false;
  }
}
