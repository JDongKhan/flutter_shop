import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:flutter_shop/page/category/widget/recommend_tags_widget.dart';
import 'package:flutter_shop/page/search/page/shop_search_result_page.dart';
import 'package:get/get.dart';

import '../../../../widgets/searchbar/search_bar.dart';
import '../../../../widgets/searchbar/search_widget.dart';
import '../controller/order_list_controller.dart';
import '../widget/order_list_widget.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _tabs = [
    {
      "title": "全部",
      "controller": OrderListController('全部'),
    },
    {
      "title": "已付款",
      "controller": OrderListController("已付款"),
    },
    {
      "title": "已发货",
      "controller": OrderListController("已发货"),
    },
    {
      "title": "已退款",
      "controller": OrderListController("已退款"),
    },
    {
      "title": "待评价",
      "controller": OrderListController("待评价"),
    }
  ];
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: _tabs.length, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('问诊单'),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Row(children: [
                // const BackButton(),
                Expanded(child: _buildSearch()),
              ]),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: _tabs
                    .map((e) => Tab(
                          child: Text(e['title']),
                        ))
                    .toList(),
              ),
              const Divider(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _tabs
                      .map((e) => OrderListWidget(
                            item: e,
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return SearchBar(
      color: Colors.grey[100]!,
      onTap: () {
        showCustomSearch(
          context: context,
          builder: (context, constraints, query) {
            logger.i('开始查询数据:$query');
            if (query.isBlank!) {
              return RecommendTagsWidget(
                onClick: (title) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ShopSearchResultPage(
                      query: title,
                    );
                  }));
                },
              );
            }
            return SearchTagList(
              query: query,
            );
          },
        );
      },
    );
  }
}
