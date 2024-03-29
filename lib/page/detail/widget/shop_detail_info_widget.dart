import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/page/city/page/city_select_list_page.dart';

import '../../model/shop_info.dart';
import 'shop_detail_navigator_widget.dart';

/// @author jd

class ShopDetailInfoWidget extends StatefulWidget {
  const ShopDetailInfoWidget(
    this.shopInfo, {
    this.navigatorController,
  });
  final ShopInfo shopInfo;
  final ShopDetailNavigatorController? navigatorController;
  @override
  State createState() => _ShopDetailInfoWidgetState();
}

class _ShopDetailInfoWidgetState extends State<ShopDetailInfoWidget> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _commentKey = GlobalKey();
  final GlobalKey _productDetailKey = GlobalKey();
  int _currentIndex = 0;
  double _commentOffset = 0.0;
  double _productDetailOffset = 0.0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      RenderBox renderObject =
          _commentKey.currentContext?.findRenderObject() as RenderBox;
      _commentOffset = renderObject.localToGlobal(Offset.zero).dy;

      RenderBox renderObject2 =
          _productDetailKey.currentContext?.findRenderObject() as RenderBox;
      _productDetailOffset = renderObject2.localToGlobal(Offset.zero).dy;
    });
    widget.navigatorController?.onClickTabItem = (int index) {
      _scrollAtIndex(index);
    };
  }

  void _scrollAtIndex(int index) {
    if (_currentIndex == index) {
      return;
    }
    print('滚动到:$index');
    double offset = 0;
    if (index == 1) {
      offset = _commentOffset;
    } else if (index == 2) {
      offset = _productDetailOffset;
    }
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    _currentIndex = index;
  }

  void _onScroll(double offset, bool userScroll) {
    // if (userScroll) {
    //切换导航tabbar
    int tempIndex = 0;
    if (offset >= _commentOffset - 110) {
      tempIndex = 1;
    }
    if (offset >= _productDetailOffset - 110) {
      tempIndex = 2;
    }

    widget.navigatorController?.tabIndex = tempIndex;
    // }
    //修改导航alpha
    double alpha = offset / 100.0;
    if (alpha < 0.0) {
      alpha = 0.0;
    } else if (alpha > 1.0) {
      alpha = 1.0;
    }
    // print('alpha:$alpha');
    widget.navigatorController?.alpha = alpha;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (ScrollUpdateNotification scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification &&
              scrollNotification.depth == 0) {
            _onScroll(scrollNotification.metrics.pixels,
                scrollNotification.dragDetails != null);
          }
          return true;
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildProductImage(),
            _buildProductInfo(),
            _buildLogistics(),
            _buildComment(),
            _buildProductDetail(),
            _buildTips(),
          ],
        ),
      ),
    );
  }

  /// 商品大图
  Widget _buildProductImage() {
    return SliverToBoxAdapter(
      child: Image.asset(AssetBundleUtils.getImgPath('meinv2')),
    );
  }

  /// 商品简介
  Widget _buildProductInfo() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '￥${widget.shopInfo.price}',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.shopInfo.shopName ?? '',
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const Text(
                  '商品编码:106647379',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    ToastUtils.toast('复制成功');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '点击复制',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Text('滋润柔肤，清洁保湿',
                style: TextStyle(
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }

  /// 物流信息
  Widget _buildLogistics() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                const Text('已选'),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: Text(
                    '规格:1L, 系列:薰衣草 1件',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('送至'),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      getResult(context);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text(
                                    '江苏南京玄武全区',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '23:00前付款，预计明天（6月18日）送达',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.grey[400],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: const <Widget>[
                Text('运费'),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    '免运费',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 评论
  Widget _buildComment() {
    return SliverToBoxAdapter(
      child: Container(
        key: _commentKey,
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
          bottom: 10,
        ),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('评价(5.8万+)'),
                DirectionButton(
                  text: const Text(
                    '99%好评',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[400],
                  ),
                  alignment: IconTextAlignment.iconRightTextLeft,
                ),
              ],
            ),
            const Divider(
              height: 1,
            ),
            _buildCommentItem(),
            const Divider(
              height: 1,
            ),
            _buildCommentItem(),
            Center(
              child: OutlinedButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                onPressed: () {},
                child: const Text('查看全部评价'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem() {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                AssetBundleUtils.getImgPath('recommend_customer_icon'),
                width: 40,
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('1*****0'),
                  StarRatingWidget(
                    value: 4.5,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Text('物流很快，昨晚下单今天就收到了，价格又很便宜还是大瓶的，很不错哦，给个五星'),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(10)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    AssetBundleUtils.getImgPath('ali_connors'),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(10)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    AssetBundleUtils.getImgPath('ali_connors'),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(10)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    AssetBundleUtils.getImgPath('ali_connors'),
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 商品详情
  Widget _buildProductDetail() {
    return SliverToBoxAdapter(
      child: Container(
        key: _productDetailKey,
        margin: const EdgeInsets.only(top: 10),
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  width: 50,
                  child: Divider(
                    endIndent: 10,
                    color: Colors.grey,
                    height: 1,
                  ),
                ),
                Text('宝贝详情'),
                SizedBox(
                  width: 50,
                  child: Divider(
                    indent: 10,
                    color: Colors.grey,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            _buildProductDetailImage('guide1'),
            _buildProductDetailImage('guide2'),
            _buildProductDetailImage('guide3'),
            _buildProductDetailImage('guide4'),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetailImage(String image) {
    return Image.asset(AssetBundleUtils.getImgPath(image));
  }

  Widget _buildTips() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text('温馨提示'),
            Text(
              '1、网站为您提供的送货、安装、维修等服务可能需要收取一定的服务费用和远程费。 \n2、服务中可能涉及的材料费请以服务工程师出示的报价单为准。\n3、如存在收费争议，可咨询在线客服或拨打客服电话110',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
