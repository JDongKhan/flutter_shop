import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:get/get.dart';

import '../../../model/carI_item.dart';
import '../../../model/shop_info.dart';
import '../controller/shop_car_controller.dart';
import '../widget/shop_car_bottom_widget.dart';
import '../widget/shop_car_item.dart';

/// @author jd

class ShopCarPage extends StatefulWidget {
  const ShopCarPage({Key? key}) : super(key: key);

  @override
  State createState() => _ShopCarPageState();
}

class _ShopCarPageState extends State<ShopCarPage> {
  final ShopCarController _viewModel = Get.put(ShopCarController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: const Text('购物车'),
        actions: [
          TextButton(
            child: const Text(
              '添加购物车',
            ),
            onPressed: () {
              _viewModel.add(
                CarItem(
                    ShopInfo(
                      icon: AssetBundleUtils.getImgPath('defalut_product'),
                      shopName: '潘婷染烫修护润发精华素750ml修复烫染损伤受损干枯发质',
                      price: 48.80,
                    ),
                    1),
              );
              _viewModel.update();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildListItem(),
          ),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          const ShopCarBottomWidget(),
        ],
      ),
    );
  }

  Widget _buildListItem() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GetBuilder<ShopCarController>(
        assignId: true,
        builder: (c) {
          return EasyRefresh(
            onRefresh: c.onRefresh,
            // onLoad: c.onLoad,
            child: ListView.builder(
              itemCount: _viewModel.data.length,
              itemBuilder: (context, int index) {
                CarItem item = _viewModel.data[index];
                return ShopCarItem(item);
              },
            ),
          );
        },
      ),
    );
  }
}
