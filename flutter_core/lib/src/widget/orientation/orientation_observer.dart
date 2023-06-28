import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// @author jd

///转屏处理器，拦截导航，统一处理
abstract class OrientationAware {
  List<DeviceOrientation>? orientations();
  bool get full;
}

class OrientationObserver extends NavigatorObserver {
  static OrientationObserver? observer;

  OrientationObserver._({
    this.orientations = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ],
  });
  final List<DeviceOrientation> orientations;
  final Map<Route, OrientationAware> _orientationSubscribers = {};

  /// Only for internal usage.
  factory OrientationObserver.instance(
      {List<DeviceOrientation> orientations = const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight
      ]}) {
    observer ??= OrientationObserver._(orientations: orientations);
    return observer!;
  }

  void subscribe(OrientationAware aware, Route route) {
    _orientationSubscribers.putIfAbsent(route, () => aware);
    List<DeviceOrientation>? orientations =
        aware.orientations() ?? this.orientations;
    SystemChrome.setPreferredOrientations(orientations);

    debugPrint('[${route.settings.name}]屏幕方向:$orientations');
    debugPrint('[${route.settings.name}]是否全屏:${aware.full}');
    if (aware.full == true) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
  }

  void unsubscribe(OrientationAware aware) {
    _orientationSubscribers.remove(aware);
  }

  void _reset(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null) return;
    _handleOrientations(route);
  }

  static void reset(BuildContext context) {
    OrientationObserver.instance()._reset(context);
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint('App Observer - didPush');
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint('App Observer - didPop');
    _handleOrientations(previousRoute);
  }

  @override
  void didRemove(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint('App Observer - didRemove');
    _handleOrientations(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint('App Observer - didReplace');
  }

  void _handleOrientations(Route<dynamic>? route) {
    OrientationAware? orientationAware = _orientationSubscribers[route];
    List<DeviceOrientation>? orientations;
    if (orientationAware == null) {
      orientations = this.orientations;
    } else {
      orientations = orientationAware.orientations();
    }
    debugPrint('[${route?.settings.name}]屏幕方向:$orientations');
    SystemChrome.setPreferredOrientations(orientations ?? this.orientations);

    debugPrint('[${route?.settings.name}]是否全屏:${orientationAware?.full}');
    if (orientationAware?.full == true) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
  }

  @override
  void didStartUserGesture(
      Route<dynamic>? route, Route<dynamic>? previousRoute) {
    debugPrint('App Observer - didStartUserGesture');
  }

  @override
  void didStopUserGesture() {
    debugPrint('App Observer - didStopUserGesture');
  }
}
