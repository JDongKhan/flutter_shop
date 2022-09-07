import 'package:flutter/material.dart';
import 'package:flutter_shop/controller/user_info_controller.dart';
import 'package:flutter_shop/utils/asset_bundle_utils.dart';
import 'package:get/get.dart';

import '../../utils/navigation_util.dart';
import '../../widgets/blurrect.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late FocusNode _namefocusNode, _pwfocusNode;
  late TextEditingController _nameController, _pwController;
  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _pwController = TextEditingController();
    _namefocusNode = FocusNode();
    _pwfocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBackground(),
          BlurRectWidget(
            sigmaX: 20,
            sigmaY: 20,
            child: Container(),
          ),
          SafeArea(
            //安全区，主要兼容屏幕
            child: _buildLogin(),
          ),
          SafeArea(
            child: Container(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Image.asset(
      AssetBundleUtils.getImgPath("login_background"),
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildLogin() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always, //开启自动校验
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 40.0), // 空出80高度
          const Center(
            //居中
            child: Text(
              '登录',
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ),
          const SizedBox(height: 50.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              focusNode: _namefocusNode,
              controller: _nameController,
              obscureText: false,
              textInputAction: TextInputAction.next,
              validator: (String? v) {
                // 校验用户名
                return (v ?? '').trim().isNotEmpty ? null : '手机号不能为空';
              },
              onFieldSubmitted: (String input) {
                _namefocusNode.unfocus();
                FocusScope.of(context).requestFocus(_pwfocusNode);
              },
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.account_box,
                  color: Colors.white,
                ),
                labelText: '手机号',
                fillColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
                errorStyle: TextStyle(color: Colors.black87),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              focusNode: _pwfocusNode,
              controller: _pwController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (String? v) {
                //校验密码
                return (v ?? '').trim().length > 6 ? null : '密码不能少于6位';
              },
              onFieldSubmitted: (String input) {
                _pwfocusNode.unfocus();
              },
              decoration: const InputDecoration(
                icon: Icon(Icons.settings, color: Colors.white),
                labelText: '登录密码',
                labelStyle: TextStyle(color: Colors.white),
                errorStyle: TextStyle(color: Colors.black87),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            height: 50,
            child: RaisedButton(
              child: const Text(
                '登录',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              highlightColor: Colors.red[100],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              onPressed: () {
                _loginAction();
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 80,
                height: 40,
                child: FlatButton(
                  textColor: Colors.white,
                  highlightColor: Colors.blue[100],
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  onPressed: () {
                    _registerAction();
                  },
                  child: const Text(
                    '注册',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              SizedBox(
                width: 80,
                height: 40,
                child: FlatButton(
                  textColor: Colors.white,
                  highlightColor: Colors.blue[100],
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  onPressed: () {},
                  child: const Text('忘记密码', style: TextStyle(fontSize: 14)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _loginAction() {
    if (!(_formKey.currentState as FormState).validate()) {
      //验证通过提交数据
      return;
    }
    String account = _nameController.text;
    String password = _pwController.text;
    UserInfoController userInfoController = Get.find<UserInfoController>();
    userInfoController.login();
    NavigationUtil.goBack();
  }

  void _registerAction() {
    NavigationUtil.push(RegisterPage());
  }
}
