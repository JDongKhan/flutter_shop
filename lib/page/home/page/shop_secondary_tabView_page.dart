import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ShopSecondaryTabViewPage extends StatefulWidget {
  const ShopSecondaryTabViewPage(this.tabKey, this.info, {super.key});
  final String tabKey;
  final Map info;
  @override
  State createState() => _ShopSecondaryTabViewPageState();
}

class _ShopSecondaryTabViewPageState extends State<ShopSecondaryTabViewPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late final TabController secondaryTC;
  late List list;
  @override
  void initState() {
    list = widget.info['subCategory'];
    secondaryTC = TabController(length: list.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final TabBar secondaryTabBar = TabBar(
      controller: secondaryTC,
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2.0,
      isScrollable: false,
      unselectedLabelColor: Colors.blue,
      tabs: list
          .map(
            (e) => Tab(text: e['name']),
          )
          .toList(),
    );
    return Column(
      children: <Widget>[
        Container(
          color: Colors.orange,
          child: secondaryTabBar,
        ),
        Expanded(
          child: TabBarView(
            controller: secondaryTC,
            children: list.map((e) => _buildTabPage(e)).toList(),
          ),
        )
      ],
    );
  }

  Widget _buildTabPage(Map e) {
    int index = list.indexOf(e);
    if (index == 0) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverFillRemaining(
            child: Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('tab4'),
            ),
          )
        ],
      );
    }
    return TabViewItem(Key('${e['name']}'));
  }

  @override
  bool get wantKeepAlive => true;
}

class TabViewItem extends StatefulWidget {
  const TabViewItem(this.tabKey, {super.key});

  final Key tabKey;

  @override
  State createState() => _TabViewItemState();
}

class _TabViewItemState extends State<TabViewItem>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Widget child = ExtendedVisibilityDetector(
      uniqueKey: widget.tabKey,
      child: GlowNotificationWidget(
        //margin: EdgeInsets.only(left: 190.0),
        ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemBuilder: (BuildContext c, int i) {
              return Container(
                //decoration: BoxDecoration(border: Border.all(color: Colors.orange,width: 1.0)),
                alignment: Alignment.center,
                height: 60.0,
                width: double.infinity,
                //color: Colors.blue,
                child: Text('${widget.tabKey}: List$i'),
              );
            },
            itemCount: 100,
            padding: const EdgeInsets.all(0.0)),
        showGlowLeading: false,
      ),
    );

    return child;
  }

  @override
  bool get wantKeepAlive => true;
}
