import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/utils/toast_utils.dart';

import '../../../utils/screen_utils.dart';
import '../vm/register_vm.dart';
import '../widget/verify_code_button.dart';

///没有多余的手机号了，只能登录，没法注册

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterController registerController = RegisterController();

  late double horPadding;
  @override
  void initState() {
    horPadding = get_Width(15);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: horPadding),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 0, top: 50),
                child: GestureDetector(
                  onTap: clickBackBtn,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: get_Width(20),
                  ),
                ),
              ),

              appBar(),

              ///input area
              inputArea(),
              SizedBox(height: get_Width(100)),

              ///btn
              GestureDetector(
                onTap: clickBtn,
                child: buildBtn(registerController.getBtnText(),
                    registerController.getBgColor(), Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget inputArea() {
    switch (registerController.phase) {
      case Phase.MobileNumber:
        return inputPhone();
      case Phase.Password:
        return inputPWD();
      case Phase.VerifyCode:
        return inputVerifyCode();
        break;
      case Phase.SetPWD:
        // TODO: Handle this case.
        break;
      case Phase.NickName:
        // TODO: Handle this case.
        break;
    }
    return inputPhone();
  }

  Widget inputPWD() {
    return Container(
      height: get_Width(80),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey, width: get_Width(1)))),
      child: TextField(
        controller: registerController.pwdController,
        onChanged: (text) {
          registerController.setPWD(text);
        },
        obscureText: true,
        style: TextStyle(color: Colors.black, fontSize: get_Sp(32)),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入密码',
          hintStyle: TextStyle(color: Colors.grey, fontSize: get_Sp(30)),
          suffixIcon: GestureDetector(
            onTap: () {
              if (registerController.pwdController != null) {
                registerController.clearPWD();
              }
            },
            child: Icon(
              Icons.clear,
              color: Colors.grey,
              size: get_Width(50),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputPhone() {
    return Container(
      height: get_Width(60),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey, width: get_Width(1)))),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: registerController.phoneController,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),
          LengthLimitingTextInputFormatter(11),
        ],
        onChanged: (text) {
          registerController.setPhone(text);
        },
        style: TextStyle(color: Colors.black, fontSize: get_Sp(22)),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入手机号',
          hintStyle: TextStyle(color: Colors.grey, fontSize: get_Sp(20)),
          suffixIcon: GestureDetector(
            onTap: () {
              if (registerController.phoneController != null) {
                registerController.clearPhone();
              }
            },
            child: Icon(
              Icons.clear,
              color: Colors.grey,
              size: get_Width(20),
            ),
          ),
        ),
      ),
    );
  }

  //获取验证码
  Widget inputVerifyCode() {
    return Container(
      height: get_Width(80),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.grey, width: get_Width(1)))),
      child: TextField(
        controller: registerController.codeController,
        onChanged: (text) {
          registerController.setCode(text);
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter(RegExp('[0-9]'), allow: true),
          LengthLimitingTextInputFormatter(6),
        ],
        style: TextStyle(color: Colors.black, fontSize: get_Sp(32)),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入验证码',
          hintStyle: TextStyle(color: Colors.grey, fontSize: get_Sp(30)),
          suffixIcon: VerifyCodeButton(),
        ),
      ),
    );
  }

  Widget buildBtn(String title, Color bgColor, Color textColor) {
    return Container(
      height: get_Width(60),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: Colors.white, width: get_Width(1)),
          borderRadius: BorderRadius.circular(get_Height(50))),
      child: Text(
        title,
        style: TextStyle(fontSize: get_Sp(22), color: textColor),
      ),
    );
  }

  Widget appBar() {
    return Container(
      height: 260,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '手机号登录',
            style: TextStyle(color: Colors.black, fontSize: get_Sp(22)),
          ),
        ],
      ),
    );
  }

  void clickBackBtn() {
    switch (registerController.phase) {
      case Phase.MobileNumber:
        Navigator.of(context).pop();
        break;
      case Phase.Password:
        registerController.updatePhase(Phase.MobileNumber);
        break;
      case Phase.VerifyCode:
        registerController.updatePhase(Phase.MobileNumber);
        break;
      case Phase.SetPWD:
        // TODO: Handle this case.
        break;
      case Phase.NickName:
        // TODO: Handle this case.
        break;
    }
  }

  void clickBtn() {
    switch (registerController.phase) {
      case Phase.MobileNumber:
        if (registerController.phone.isEmpty) {
          ToastUtils.toast('手机号不能为空');
          return;
        }
        //调接口检查是否注册过了
        registerController.checkAccount().then((value) => {
              if (value == null)
                {
                  registerController.updatePhase(Phase.VerifyCode),
                }
              else if (value['loginType'] == 0)
                {
                  registerController.updatePhase(Phase.VerifyCode),
                }
              else
                {
                  registerController.updatePhase(Phase.Password),
                }
            });

        break;
      case Phase.Password:
        if (registerController.pwd.isEmpty) {
          ToastUtils.toast('密码不能为空');
          return;
        }
        //registerVM.updatePhase(Phase.MobileNumber);
        break;
      case Phase.VerifyCode:
        if (registerController.code.isEmpty) {
          ToastUtils.toast('验证码不能为空');
          return;
        }
        break;
      case Phase.SetPWD:
        // TODO: Handle this case.
        break;
      case Phase.NickName:
        // TODO: Handle this case.
        break;
    }
  }
}
