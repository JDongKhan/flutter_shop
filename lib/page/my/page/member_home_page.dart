import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';

import '../../../style/styles.dart';
import '../model/shop_content.dart';

/// @author jd

class MemberHomePage extends StatefulWidget {
  @override
  _MemberHomePageState createState() => _MemberHomePageState();
}

class _MemberHomePageState extends State<MemberHomePage> {
  List<ShopContent>? _allContents;

  @override
  void initState() {
    _allContents = List.generate(
      50,
      (int index) => ShopContent(
          title: '梅西${index}年挣6.74亿>詹皇+布雷迪生涯总和KD：太疯狂！',
          source: '网易体育',
          commentNum: '12${index}',
          img: 'bg_${index % 5}',
          flag: '0'),
    );
    super.initState();
  }

  Widget _buildBackHomeList() {
    return ListView.separated(
      itemBuilder: (c, idx) {
        ShopContent content = _allContents![idx];
        return ListTile(
          // dense: true,
          // visualDensity: VisualDensity(vertical: 10),
          contentPadding:
              const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 0),
          title: Text(
            content.title ?? '',
            style: const TextStyle(color: Colors.black87, fontSize: 18),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            child: Text(
              '${content.source}  ${content.commentNum}评论',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          trailing: Image.asset(
            AssetBundleUtils.getImgPath(content.img, format: 'jpg'),
            width: 100,
            fit: BoxFit.fill,
          ),
        );
      },
      separatorBuilder: (c, idx) {
        return const Divider();
      },
      itemCount: _allContents?.length ?? 0,
    );
  }

  Widget _buildBackHome() {
    return Column(
      children: <Widget>[
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.grey,
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 0, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      AssetBundleUtils.getImgPath('user_head_0'),
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '卡其色的基毛杜鹃',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          '我的账号：393465026',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                '留下你的个性签名，让大家了解和关注你',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  _numWidget('关注', '7'),
                  const SizedBox(
                    width: 20,
                  ),
                  _numWidget('粉丝', '0'),
                  const SizedBox(
                    width: 20,
                  ),
                  _numWidget('获赞', '0'),
                  Expanded(child: Container()),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '编辑资料',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      padding: const EdgeInsets.all(5),
                      side: const BorderSide(color: Colors.white),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(
                      Icons.message_outlined,
                      size: 18,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildBackHomeList(),
        ),
      ],
    );
  }

  Widget _buildDragList(ScrollController scrollController) {
    return Container(
      color: Colors.blue[100],
      child: ListView.builder(
        controller: scrollController,
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text('推荐列表---- $index'));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: const Text('个人主页'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            alignment: Alignment.topLeft,
            child: FractionallySizedBox(
              heightFactor: .9,
              child: _buildBackHome(),
            ),
          ),
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              print('#####################');
              print('minExtent = ${notification.minExtent}');
              print('maxExtent = ${notification.maxExtent}');
              print('initialExtent = ${notification.initialExtent}');
              print('extent = ${notification.extent}');
              return true;
            },
            child: DraggableScrollableSheet(
              expand: true,
              initialChildSize: 0.1,
              minChildSize: 0.1,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.blue[100],
                        child: const Center(
                          child: Icon(Icons.menu),
                        ),
                      ),
                      Expanded(child: _buildDragList(scrollController)),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _numWidget(String text, String num) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$num',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        Text(
          '$text',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
