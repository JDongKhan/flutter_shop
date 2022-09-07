import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/base/base_common_controller.dart';

/*
* 没有多余的手机号了，没法写注册了
*
* */

enum Phase {
  MobileNumber, //输入手机号
  Password, //输入密码
  VerifyCode, //输入验证码
  SetPWD, //设置密码
  NickName, //设置昵称
}

class RegisterController extends BaseCommonController {
  Phase phase = Phase.MobileNumber;
  updatePhase(Phase phase) {
    this.phase = phase;
    update();
  }

  TextEditingController phoneController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  String phone = '';
  String pwd = '';
  String code = '';

  void setPhone(String text) {
    phone = text;
    update();
  }

  void setPWD(String text) {
    pwd = text;
    update();
  }

  void setCode(String cd) {
    code = cd;
    update();
  }

  String getBtnText() {
    switch (phase) {
      case Phase.MobileNumber:
        return '下一步';
      case Phase.Password:
        return '登录';
      case Phase.VerifyCode:
        return '登录';
        break;
      case Phase.SetPWD:
        // TODO: Handle this case.
        break;
      case Phase.NickName:
        // TODO: Handle this case.
        break;
    }
    return '';
  }

  final Color redColor = Color.fromRGBO(240, 44, 31, 1);
  final Color redColorA = Color.fromRGBO(240, 44, 31, 0.3);

  Color getBgColor() {
    switch (phase) {
      case Phase.MobileNumber:
        return phone.isEmpty ? redColorA : redColor;
      case Phase.Password:
        return pwd.isEmpty ? redColorA : redColor;
      case Phase.VerifyCode:
        return code.isEmpty ? redColorA : redColor;
        break;
      case Phase.SetPWD:
        // TODO: Handle this case.
        break;
      case Phase.NickName:
        // TODO: Handle this case.
        break;
    }
    return Colors.black;
  }

  void clearPhone() {
    phoneController.clear();
    phone = '';
    update();
  }

  void clearPWD() {
    pwdController.clear();
    pwd = '';
    update();
  }

  Future checkAccount() async {
    return null;
  }

  @override
  Future loadData() async {
    return null;
  }
}
