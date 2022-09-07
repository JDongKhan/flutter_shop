import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../model/shop_info.dart';
import '../controller/shop_detail_controller.dart';
import '../widget/shop_detail_bottom_bar.dart';
import '../widget/shop_detail_info_widget.dart';
import '../widget/shop_detail_navigator_widget.dart';

/// @author jd

class ShopDetailPage extends StatefulWidget {
  final ShopInfo shopInfo;
  const ShopDetailPage(this.shopInfo, {Key? key}) : super(key: key);
  @override
  State createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  final ShopDetailNavigatorController _controller =
      ShopDetailNavigatorController();
  ShopDetailController controller = Get.put(ShopDetailController());
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: _buildContent(),
        bottomNavigationBar: ShopDetailBottomBar(),
      ),
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        ShopDetailInfoWidget(
          widget.shopInfo,
          navigatorController: _controller,
        ),
        ShopDetailNavigatorWidget(
          navigatorController: _controller,
        ),
      ],
    );
  }
}
