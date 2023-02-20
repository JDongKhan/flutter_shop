import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/controller/user_info_controller.dart';
import 'package:get/get.dart';

import '../../../model/shop_info.dart';
import '../../cart_2/shop_car2_page.dart';
import '../controller/shop_car_controller.dart';

/// @author jd

class ShopCarBottomWidget extends StatelessWidget {
  const ShopCarBottomWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      color: Colors.white,
      child: GetBuilder<ShopCarController>(
        builder: (controller) {
          return Row(
            children: <Widget>[
              CircleCheckBox.icon(
                value: controller.allChecked,
                onChanged: (value) {
                  for (var element in controller.data) {
                    element.checked = value;
                  }
                  controller.update();
                },
              ),
              const Text('全选'),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text('总价: ${controller.totalPrice.toStringAsFixed(2)}'),
              ),
              const SizedBox(
                width: 10,
              ),
              Builder(
                builder: (context) => TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      left: 25,
                      right: 25,
                    ),
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (controller.checkedList.isEmpty) {
                      ToastUtils.toast('请选择商品');
                      return;
                    }
                    UserInfoController userController =
                        Get.find<UserInfoController>();
                    if (!userController.isLogin) {
                      UserInfoController.testLogin(context);
                      return;
                    }

                    List<ShopInfo> shopInfos =
                        controller.checkedList.map((e) => e.shopInfo).toList();
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (c) => ShopCar2Page(
                          shopInfoList: shopInfos,
                        ),
                      ),
                    );
                  },
                  child: const Text('去结算'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
