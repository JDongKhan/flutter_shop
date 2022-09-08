import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_shop/controller/user_info_controller.dart';
import 'package:flutter_shop/page/login/page/register_page.dart';
import 'package:get/get.dart';

import '../widget/bobble_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;

  @override
  void initState() {
    _fadeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800));
    _fadeAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: BobbleWidget(
          child: Stack(
            children: [
              //  第四部分 顶部的稳步
              buildTopText(),
              //  第五部分 输入区域
              buildBottomColumn()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopText() {
    return const Positioned(
      left: 0,
      right: 0,
      top: 160,
      child: Text(
        '登录',
        style: TextStyle(fontSize: 44, color: Colors.deepPurple),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildBottomColumn() {
    return Positioned(
      left: 44,
      right: 44,
      bottom: 84,
      child: FadeTransition(
        opacity: _fadeAnimationController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //  自定义文本输入框
            const TextFieldWidget(
              obscureText: false,
              labelText: "账号",
              prefixIconData: Icons.phone_android_outlined,
            ),
            const SizedBox(
              height: 14,
            ),
            const TextFieldWidget(
              obscureText: true,
              labelText: "密码",
              prefixIconData: Icons.lock_outline,
              suffixIconData: Icons.visibility,
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    '返回',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
                const Text(
                  '忘记密码',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            SizedBox(
              height: 42,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  UserInfoController userInfoController =
                      Get.find<UserInfoController>();
                  userInfoController.login();
                },
                child: const Text('登录'),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            SizedBox(
              height: 42,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RegisterPage(),
                    ),
                  );
                },
                child: const Text('注册'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final Function(String value)? onChanged;
  final bool obscureText;
  final String? labelText;
  final IconData? prefixIconData;
  final IconData? suffixIconData;

  const TextFieldWidget({
    Key? key,
    this.onChanged,
    this.obscureText = false,
    this.labelText,
    this.prefixIconData,
    this.suffixIconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: obscureText,
      style: TextStyle(color: Colors.blue, fontSize: 14.0),
      //  输入框可用时边框配置
      decoration: InputDecoration(
        filled: true,
        labelText: labelText,
        // 去掉默认的下划线
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
        // 获取输入焦点时的边框样式
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.blue)),
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: Colors.blue,
        ),
        suffixIcon: Icon(
          suffixIconData,
          size: 18,
          color: Colors.blue,
        ),
      ),
    );
  }
}
