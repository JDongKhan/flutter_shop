import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/base/get_loading_widget.dart';

import '../../../../utils/navigation_util.dart';
import '../controller/order_list_controller.dart';
import '../model/order_info.dart';

class OrderListWidget extends StatefulWidget {
  const OrderListWidget({Key? key, required this.item}) : super(key: key);
  final Map item;
  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  @override
  Widget build(BuildContext context) {
    OrderListController controller = widget.item['controller'];
    // controller.refreshController = refreshController;
    print("tag:${controller.tag}");
    return GetXLoadingWidget<OrderListController>(
      init: controller,
      tag: controller.tag,
      key: ValueKey(controller),
      builder: (OrderListController controller) {
        List<OrderInfo> list = controller.data;
        return EasyRefresh(
          header: const CupertinoHeader(emptyWidget: Text('暂无数据')),
          footer: const CupertinoFooter(),
          onRefresh: controller.onRefresh,
          onLoad: controller.onLoad,
          child: ListView.separated(
            separatorBuilder: (c, idx) {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemBuilder: (c, idx) {
              OrderInfo info = list[idx];
              return _buildProductItem(info);
            },
            itemCount: list.length,
          ),
        );
      },
    );
  }

  Widget _buildProductItem(OrderInfo info) {
    return ListTile(
      leading: Image.asset(AssetBundleUtils.getImgPath(info.image)),
      title: Text(info.productName ?? ''),
      subtitle: Text('价格:${info.price},数量:${info.productNum}'),
      onTap: () {
        NavigationUtil.push('/order_detail');
      },
    );
  }
}
