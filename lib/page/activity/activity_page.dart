import 'package:flutter/material.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final data = {
    "精选商品": [
      "Item 1 (A)",
      "Item 2 (A)",
      "Item 3 (A)",
      "Item 4 (A)",
      "Item 5 (A)",
      "Item 6 (A)",
      "Item 7 (A)",
      "Item 8 (A)",
      "Item 9 (A)",
    ],
    "母婴货品": [
      "Item 1 (B)",
      "Item 2 (B)",
      "Item 3 (B)",
      "Item 4 (B)",
      "Item 5 (B)",
      "Item 6 (B)",
    ],
    "汽车配件": [
      "Item 1 (C)",
      "Item 2 (C)",
      "Item 3 (C)",
      "Item 4 (C)",
      "Item 5 (C)",
      "Item 6 (C)",
      "Item 7 (C)",
      "Item 8 (C)",
    ],
    "零食酒水": [
      "Item 1 (D)",
      "Item 2 (D)",
      "Item 3 (D)",
      "Item 4 (D)",
      "Item 5 (D)",
      "Item 6 (D)",
      "Item 7 (D)",
      "Item 8 (D)",
      "Item 9 (D)",
    ],
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("活动列表"),
      ),
      body: ScrollableListTabScroller(
        headerContainerBuilder: (BuildContext context, Widget child) {
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              width: double.infinity,
              child: child);
        },
        tabBuilder: (BuildContext context, int index, bool active) => Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Text(
            data.keys.elementAt(index),
            style: !active
                ? null
                : const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) => Column(
          children: [
            Text(
              data.keys.elementAt(index),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ...data.values
                .elementAt(index)
                .asMap()
                .map(
                  (index, value) => MapEntry(
                    index,
                    ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        alignment: Alignment.center,
                        child: Text(index.toString()),
                      ),
                      title: Text(value),
                    ),
                  ),
                )
                .values
          ],
        ),
      ),
    );
  }
}
