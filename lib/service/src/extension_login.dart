import 'services_path.dart';

/// @author jd

extension LoginService on ServicesPath {
  ///登录接口
  String get loginUrl => '${services.loginUrl}/user/login.do';

  //用户信息
  String get userInfo => '${services.baseUrl}/app/user.do';
}
