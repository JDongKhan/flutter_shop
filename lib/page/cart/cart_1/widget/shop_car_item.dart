import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/circle_check_box.dart';
import '../../../../widgets/step_number_widget.dart';
import '../../../model/carI_item.dart';
import '../vm/shop_car_view_model.dart';

/// @author jd
class ShopCarItem extends StatefulWidget {
  ShopCarItem(this.carItem);
  final CarItem carItem;
  @override
  State createState() => _ShopCarItemState();
}

class _ShopCarItemState extends State<ShopCarItem> {
  @override
  Widget build(BuildContext context) {
    ShopCarViewModel viewModel = Get.find<ShopCarViewModel>();
    CarItem item = widget.carItem;
    bool checked = item.checked;
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      color: Colors.white,
      child: Row(
        children: [
          CircleCheckBox(
            value: checked,
            onChanged: (value) {
              viewModel.checkItem(item, value);
            },
          ),
          if (item.shopInfo.icon != null)
            Image.asset(
              item.shopInfo.icon!,
              width: 80,
              height: 80,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(item.shopInfo.shopName ?? ''),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  '商品编码： 000000101029384',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  '控油洁面',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '￥${item.shopInfo.price}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StepNumberWidget(
                      min: 0,
                      max: 10,
                      value: item.count,
                      onChanged: (v) {
                        item.count = v;
                        viewModel.update();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
