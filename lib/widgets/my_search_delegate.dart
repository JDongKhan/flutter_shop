import 'dart:async';

import 'package:flutter/material.dart';

///@Description TODO
///@Author jd

typedef ResultWidgetBuilder = Widget Function(
    BuildContext context, String? query);

/// 实现SearchDelegate
class MySearchDelegate extends SearchDelegate<String> {
  MySearchDelegate({
    this.placeholder = '搜索全网精品游戏',
    this.resultBuilder,
    this.queryBuilder,
    this.suggestionsBuilder,
  });
  final String placeholder;
  final ResultWidgetBuilder? resultBuilder;
  final ResultWidgetBuilder? queryBuilder;
  final WidgetBuilder? suggestionsBuilder;
  @override
  String get searchFieldLabel => placeholder;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        if (query.isEmpty) {
          close(context, '');
        } else {
          query = '';
          showSuggestions(context);
        }
      }, //点击时关闭整个搜索页面
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (resultBuilder != null) {
      return resultBuilder!.call(context, query);
    }
    // 简单显示搜索结果，并未真正去请求网络，后面文章会继续讲解如何通过api查询
    return Center(
      child: SizedBox(
        width: 100.0,
        height: 100.0,
        child: Card(
          color: Colors.redAccent,
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    /// 将方法作为参数传递给子组件调用，展示使用非EventBus方式通信
    return query.isEmpty
        ? _buildSuggestionsWidget(context)
        : _buildQueryListWidget(context);
  }

  Widget _buildSuggestionsWidget(BuildContext context) {
    if (suggestionsBuilder != null) {
      return suggestionsBuilder!.call(context);
    }
    return const SuggestionsWidget();
  }

  Widget _buildQueryListWidget(BuildContext context) {
    if (queryBuilder != null) {
      return queryBuilder!.call(context, query);
    }
    return QueryListWidget(query, popResults, setSearchKeyword);
  }

  /// 搜索结果展示
  void popResults(BuildContext context) {
    showResults(context);
  }

  /// 设置query
  Future<void> setSearchKeyword(String searchKeyword) async {
    query = searchKeyword;
  }
}

/// 搜索词建议widget  默认样式
class SuggestionsWidget extends StatelessWidget {
  const SuggestionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            '大家都在搜',
          ),
          SearchItemView(
            isHisSearch: false,
          ), // isHisSearch 是否历史搜索词View
          Text('历史搜索记录'),
          SearchItemView(
            isHisSearch: true,
          ),
        ],
      ),
    );
  }
}

class SearchItemView extends StatefulWidget {
  final bool isHisSearch;

  /// 是否允许删除
  const SearchItemView({super.key, this.isHisSearch = false});
  @override
  State createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  /// 历史搜索词
  List<dynamic> hisKeywords = [
    '历史1',
    '历史2',
    '历史3',
    '历史4',
  ];

  /// 推荐搜索词-大家都在搜
  List<dynamic> recommondKeywords = [
    '推荐1',
    '推荐2',
    '推荐3',
    '推荐4',
  ];

  @override
  void initState() {
    super.initState();
    _getHisKeywords();
  }

  /// 之所以定义为async，因为后续需要改造为从SharedPreferences本地获取搜索历史
  Future _getHisKeywords() async {
    return hisKeywords;
  }

  /// 之所以定义为async，因为后续需要改造为从SharedPreferences本地获删除
  Future _delHisKeywords(String keywords) async {
    if (hisKeywords.isNotEmpty && hisKeywords.contains(keywords)) {
      hisKeywords.remove(keywords);

      /// 刷新状态
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = widget.isHisSearch ? hisKeywords : recommondKeywords;
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          spacing: 10,
          children: items.map((item) {
            /// 构造Item widget
            return SearchItem(
              title: item,
              isHisSearch: widget.isHisSearch,
            );
          }).toList(),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SearchItem extends StatefulWidget {
  final String title;
  final bool isHisSearch;

  const SearchItem({Key? key, required this.title, this.isHisSearch = false})
      : super(key: key);
  @override
  State createState() => _SearchItemState(isHisSearch: this.isHisSearch);
}

class _SearchItemState extends State<SearchItem> {
  bool isHisSearch;
  _SearchItemState({this.isHisSearch = false});

  @override
  Widget build(BuildContext context) {
    /// 圆角处理
    RoundedRectangleBorder shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),

      /// 历史搜索VIEW, 允许对搜索词进行删除操作
      child: widget.isHisSearch
          ? Chip(
              onDeleted: () {},
              label: Text(widget.title),
              shape: shape,
            )
          :

          /// 大家都在搜索VIEW， 不允许对搜索词删除操作
          Chip(
              label: Text(widget.title),
              shape: shape,
            ),
    );
  }
}

class QueryListWidget extends StatefulWidget {
  final String query;
  final Function popResults;
  final Function setSearchKeyword;

  /// 这里通过另外一种方式实现自组件调用父组件方法
  const QueryListWidget(this.query, this.popResults, this.setSearchKeyword,
      {super.key});
  @override
  State<StatefulWidget> createState() => _QueryListWidgetState();
}

class _QueryListWidgetState extends State<QueryListWidget> {
  /// 加载时显示loading
  static const loadingTag = '##loadingTag##';
  List<String> searchList = [loadingTag];

  @override
  void initState() {
    super.initState();
    _receiveList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(
            // ignore: missing_return
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                if (searchList[index] == loadingTag) {
                  // 最后一个词等于加载Tag
                  if (searchList.length - 1 < 40) {
                    // 搜索量小于100 表示还有更多
                    _receiveList();
                    // 加载时显示loading
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: const SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.0) // 加载转圈
                          ),
                    );
                  } else {
                    // 已经加载了100条数据，不再获取数据
                    return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          "没有更多了",
                          style: TextStyle(color: Colors.grey),
                        ));
                  }
                }
                return ListTile(
                  title: RichText(text: bold(searchList[index], widget.query)),
                  onTap: () {
                    widget.setSearchKeyword(searchList[index]);
                    widget.popResults(context);
                  },
                );
              },
              itemCount: searchList.length,
              separatorBuilder: (context, index) => const Divider(
                height: .0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan bold(String title, String query) {
    query = query.trim();
    int index = title.indexOf(query);
    if (index == -1 || query.length > title.length) {
      return TextSpan(
        text: title,
        style: const TextStyle(color: Colors.black, fontSize: 12),
        children: null,
      );
    } else {
      /// 构建富文本，对输入的字符加粗显示
      String before = title.substring(0, index);
      String hit = title.substring(index, index + query.length);
      String after = title.substring(index + query.length);
      return TextSpan(
        text: '',
        style: const TextStyle(color: Colors.black, fontSize: 12),
        children: <TextSpan>[
          TextSpan(text: before),
          TextSpan(
              text: hit,
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          TextSpan(text: after),
        ],
      );
    }
  }

  /// 模拟网络延迟加载，需要依赖词包 english_words: ^3.1.0
  void _receiveList() {
    Future.delayed(const Duration(seconds: 2)).then((e) {
      searchList.insertAll(searchList.length - 1, ['ass', 'ssasads']);
      if (mounted) {
        setState(() {});
      }
    });
  }
}
