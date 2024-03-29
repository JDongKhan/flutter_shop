import 'package:flutter/cupertino.dart';

import 'orientation_observer.dart';

/// @author jd

mixin OrientationMixin<T extends StatefulWidget> on State<T>, OrientationAware {
  OrientationObserver? _orientationObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orientationObserver = OrientationObserver.instance();
    final route = ModalRoute.of(context);
    if (route == null) {
      return;
    }
    _orientationObserver?.subscribe(this, route);
  }

  @mustCallSuper
  @override
  void dispose() {
    _orientationObserver?.unsubscribe(this);
    super.dispose();
  }
}
