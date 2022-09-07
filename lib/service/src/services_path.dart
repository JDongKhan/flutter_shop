import '../environment.dart';
import 'services.dart';

/// @author jd

class ServicesPath {
  ServicesPath(Environment environment) {
    if (environment == Environment.prd) {
      services = ServicesPrd();
    }
    if (environment == Environment.sit) {
      services = ServicesSit();
    }
    if (environment == Environment.pre) {
      services = ServicesPre();
    }
  }
  late Services services;
}
