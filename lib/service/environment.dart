import 'package:flutter/cupertino.dart';

import 'src/services_path.dart';

export 'src/extension_login.dart';
export 'src/extension_shop.dart';
export 'src/extension_order.dart';

/// @author jd

///环境配置
enum Environment {
  ///prd
  prd,

  ///sit
  sit,

  ///pre
  pre,
}

class Environments {
  ///初始化

  void init({
    String env = 'prd',
    bool debug = false,
  }) {
    String locaEnv = env.toLowerCase();
    if (locaEnv == 'prd') {
      environment = Environment.prd;
    } else if (locaEnv == 'sit') {
      environment = Environment.sit;
    } else if (locaEnv == 'pre') {
      environment = Environment.pre;
    } else {
      environment = Environment.prd;
    }
    debugPrint('初始化环境:$environment');
    this.debug = debug;
    servicesPath = ServicesPath(environment);
  }

  ///服务配置
  late ServicesPath servicesPath;

  ///环境
  late Environment environment;

  ///是否是debug
  bool debug = false;
}

Environments environments = Environments();
