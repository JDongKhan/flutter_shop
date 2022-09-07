import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/utils/asset_bundle_utils.dart';
import 'package:flutter_shop/utils/toast_utils.dart';

import '../../../utils/screen_utils.dart';
import '../../../widgets/webview/web_page.dart';
import '../widget/logo_widget.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Color redColor = const Color.fromRGBO(220, 44, 31, 1);

  bool isAgree = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          color: redColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50),
              LogoWidget(),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () {
                  if (!isAgree) {
                    showHint();
                  } else {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => RegisterPage(),
                        ));
                  }
                },
                child: buildBtn('立即登录', Colors.white, redColor),
              ),
              SizedBox(height: get_Width(40)),
              GestureDetector(
                onTap: () {
                  if (!isAgree) {
                    showHint();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: buildBtn('立即体验', redColor, Colors.white),
              ),
              SizedBox(height: get_Width(50)),

              ///third
              thirdLogin(),
              SizedBox(height: get_Width(50)),
              contractWidget(),
            ],
          ),
        ),
      ),
    );
  }

  void showHint() {
    ToastUtils.toast('请勾选下方的同意');
  }

  Widget contractWidget() {
    return Container(
      height: 30,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              isAgree = !isAgree;
              setState(() {});
            },
            child: Row(
              children: <Widget>[
                checkWidget(),
                const Text(
                  '  同意',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                )
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: '登录即代表同意并阅读',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
              children: [
                TextSpan(
                  text: '《用户协议》',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WebPage(
                            title: '《用户协议》',
                            url: 'https://baidu.com',
                          ),
                        ),
                      );
                    },
                ),
                const TextSpan(text: '和'),
                TextSpan(
                  text: '《隐私政策》',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const WebPage(
                            title: '《隐私政策》',
                            url: 'assets/data/my.html',
                          ),
                        ),
                      );
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget checkWidget() {
    return isAgree
        ? const Icon(
            Icons.check,
            color: Colors.white,
            size: 22,
          )
        : const Icon(
            Icons.check_box_outline_blank,
            color: Colors.grey,
            size: 22,
          );
  }

  Widget thirdLogin() {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            AssetBundleUtils.getIconPath('wechat'),
            width: get_Width(80),
            height: get_Width(80),
          ),
          Image.asset(
            AssetBundleUtils.getIconPath('qq'),
            width: get_Width(80),
            height: get_Width(80),
          ),
          Image.asset(
            AssetBundleUtils.getIconPath('weibo'),
            width: get_Width(80),
            height: get_Width(80),
          ),
          Image.asset(
            AssetBundleUtils.getIconPath('logo'),
            width: get_Width(80),
            height: get_Width(80),
          ),
        ],
      ),
    );
  }

  Widget buildBtn(String title, Color bgColor, Color textColor) {
    return Container(
      width: 400,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: Colors.white, width: get_Width(1)),
          borderRadius: BorderRadius.circular(get_Height(20))),
      child: Text(
        title,
        style: TextStyle(fontSize: get_Sp(18), color: textColor),
      ),
    );
  }
}
