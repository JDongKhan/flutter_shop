import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/asset_bundle_utils.dart';

import '../../../utils/screen_utils.dart';

class LogoWidget extends StatefulWidget {
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<LogoWidget> with SingleTickerProviderStateMixin {
  final List<Widget> list = [];
  Timer? timer;
  late Image logo;

  @override
  void initState() {
    logo = Image.asset(
      AssetBundleUtils.getIconPath('logo'),
      width: 100,
      height: 100,
    );
    super.initState();

    list.add(logo);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // initTimer();
    });
  }

  void initTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        ///理论上讲 第二个总是先完成的
        list.add(WaveWidget((index) {
          list.removeAt(1);
        }));
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: list,
      ),
    );
  }
}

typedef AnimationCallback = void Function(int index);

class WaveWidget extends StatefulWidget {
  final AnimationCallback animateDone;
  WaveWidget(this.animateDone);

  @override
  _WaveWidgetState createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<WaveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation first;

  double opacity = 0.8;

  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    first = Tween<double>(begin: get_Width(180), end: get_Width(360))
        .animate(controller);
    super.initState();
//
//    controller.addStatusListener((status) {
//      if(status == AnimationStatus.completed){
//
//      }
//    });
    first.addListener(() {
      opacity = (1 - first.value / get_Width(360)).clamp(0.0, 1.0).toDouble();
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: first.value,
      height: first.value,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(opacity),
          width: get_Width(2),
        ),
      ),
    );
  }
}
