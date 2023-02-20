import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:get/get.dart';

import '../vm/register_vm.dart';
import '../widget/verify_code_button.dart';

///没有多余的手机号了，只能登录，没法注册

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterController registerController = Get.put(RegisterController());

  late double horPadding;
  @override
  void initState() {
    horPadding = 15;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: GetBuilder<RegisterController>(builder: (controller) {
          return Container(
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
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),

                appBar(),

                ///input area
                inputArea(),

                const Spacer(),

                ///btn
                Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: GestureDetector(
                    onTap: clickBtn,
                    child: buildBtn(registerController.getBtnText(),
                        registerController.getBgColor(), Colors.white),
                  ),
                )
              ],
            ),
          );
        }),
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
      height: 80,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: TextField(
        controller: registerController.pwdController,
        onChanged: (text) {
          registerController.setPWD(text);
        },
        obscureText: true,
        style: const TextStyle(color: Colors.black, fontSize: 32),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入密码',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 30),
          suffixIcon: GestureDetector(
            onTap: () {
              if (registerController.pwdController != null) {
                registerController.clearPWD();
              }
            },
            child: const Icon(
              Icons.clear,
              color: Colors.grey,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget inputPhone() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
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
        style: const TextStyle(color: Colors.black, fontSize: 22),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入手机号',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
          suffixIcon: GestureDetector(
            onTap: () {
              if (registerController.phoneController != null) {
                registerController.clearPhone();
              }
            },
            child: const Icon(
              Icons.clear,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  //获取验证码
  Widget inputVerifyCode() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
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
        style: const TextStyle(color: Colors.black, fontSize: 32),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: '请输入验证码',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 30),
          suffixIcon: VerifyCodeButton(),
        ),
      ),
    );
  }

  Widget buildBtn(String title, Color bgColor, Color textColor) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(50)),
      child: Text(
        title,
        style: TextStyle(fontSize: 22, color: textColor),
      ),
    );
  }

  Widget appBar() {
    return Container(
      height: 160,
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          Text(
            '手机号注册',
            style: TextStyle(color: Colors.black, fontSize: 22),
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
