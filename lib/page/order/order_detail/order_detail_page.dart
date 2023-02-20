import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

import '../../../utils/navigation_util.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('问诊详情'),
      ),
      body: Container(
        color: Colors.grey[100],
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 40,
                              child: const Text('病情信息'),
                            ),
                            const Divider(
                              height: 1,
                            ),
                            _buildCellWidget(title: '症状:', detail: '偶发心率不齐'),
                            _buildCellWidget(
                                title: '就医及用药情况:', detail: '偶发心率不齐'),
                            _buildCellWidget(
                                title: '需要解决的问题:', detail: '偶发心率不齐'),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 40,
                              child: const Text('诊断医生'),
                            ),
                            const Divider(
                              height: 1,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: Row(
                                children: [
                                  Image.asset(
                                    AssetBundleUtils.getImgPath('shop_0.png'),
                                    width: 150,
                                    height: 100,
                                  ),
                                  Image.asset(
                                    AssetBundleUtils.getImgPath('shop_1.png'),
                                    width: 150,
                                    height: 100,
                                  ),
                                  Image.asset(
                                    AssetBundleUtils.getImgPath('shop_2.png'),
                                    width: 150,
                                    height: 100,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      //诊断结果
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 40,
                              child: const Text('诊断结果'),
                            ),
                            const Divider(
                              height: 1,
                            ),
                            const Text('123214koscnfiowhfdhfpoaudhfiduhdfu'),
                          ],
                        ),
                      ),

                      //订单信息
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 40,
                              child: const Text('订单信息'),
                            ),
                            const Divider(
                              height: 1,
                            ),
                            _buildCellWidget(title: '订单金额:', detail: '0.0元'),
                            _buildCellWidget(title: '付款方式:', detail: '微信'),
                            _buildCellWidget(
                                title: '订单生成时间:', detail: '2022-01-02'),
                            _buildCellWidget(
                                title: '订单编号:', detail: '12321412412414'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        showAlertDialog(
                          context: context,
                          message: '退款需获得医生同意后，方可成功退款，24小时后若医生未确认，退款取消',
                        );
                      },
                      child: const Text('退款'),
                    ),
                    TextButton(
                      onPressed: () {
                        NavigationUtil.push('/rediagnosis');
                      },
                      child: const Text('复诊'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCellWidget({required String title, required String detail}) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 40,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: title,
                style: const TextStyle(fontSize: 14, color: Colors.black)),
            TextSpan(
                text: detail,
                style: const TextStyle(fontSize: 12, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
