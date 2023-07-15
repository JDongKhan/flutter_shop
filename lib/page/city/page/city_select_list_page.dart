import 'package:city_pickers/city_pickers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CitySelectListPage extends StatefulWidget {
  const CitySelectListPage({super.key});

  @override
  State<CitySelectListPage> createState() => _CitySelectListPageState();
}

class _CitySelectListPageState extends State<CitySelectListPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// 通过钩子事件, 主动唤起浮层.
Future<Result?> getResult(BuildContext context) async {
  print('start');

  Result? result = await CityPickers.showFullPageCityPicker(context: context);
  print('result $result');

  Position position = await _determinePosition();
  print('position:$position');
  // type 1 苹果风格
  // Result? result = await CityPickers.showCityPicker(
  //   context: context,
  // );
  // print('result $result');
  // // type 2 苹果风格
  // Result? result = await CityPickers.showFullPageCityPicker(
  //   context: context,
  // );
  //
  // print('result $result2');
  // // type 3
  // Result? result = await CityPickers.showCitiesSelector(
  //   context: context,
  // );
  return result;
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
