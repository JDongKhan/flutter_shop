import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/flutter_core.dart';

///@Description TODO
///@Author jd

typedef ResultWidgetBuilder = Widget Function(
    BuildContext context, BoxConstraints constraints, String? query);

Future<T?> showCustomSearch<T>({
  required BuildContext context,
  String query = '',
  required ResultWidgetBuilder builder,
  bool useRootNavigator = false,
}) {
  debugPrint('跳转到搜索');
  return Navigator.of(context, rootNavigator: useRootNavigator)
      .push(_ShopSearchPageRoute<T>(
    query: query,
    builder: builder,
  ));
}

class _ShopSearchPageRoute<T> extends PageRoute<T> {
  _ShopSearchPageRoute({
    this.query,
    required this.builder,
  });

  String? query;

  final ResultWidgetBuilder builder;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _SearchWidget<T>(
      query: query,
      builder: builder,
    );
  }

  @override
  void didComplete(T? result) {
    super.didComplete(result);
  }
}

class _SearchWidget<T> extends StatefulWidget {
  const _SearchWidget({
    Key? key,
    this.query,
    this.builder,
  }) : super(key: key);
  final String? query;
  final ResultWidgetBuilder? builder;
  @override
  _SearchWidgetState<T> createState() => _SearchWidgetState<T>();
}

class _SearchWidgetState<T> extends State<_SearchWidget<T>> {
  String? _query;

  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    _query = widget.query;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _SearchWidget<T> oldWidget) {
    _query = widget.query;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leadingWidth: 40,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: const Color(0xFFFFFFFF),
        iconTheme: IconTheme.of(context).copyWith(color: Colors.black),
        title: Container(
          height: 32,
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.only(left: 12, right: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(9.0),
            ),
            border: Border.all(
              width: 1,
              color: const Color(0xff2457F2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AssetBundleUtils.getImgPath('shop_home_search'),
                width: 16,
                height: 16,
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _editingController,
                  style: const TextStyle(fontSize: 13),
                  decoration: const InputDecoration(
                    isDense: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                    hintText: '商品名称/编码/条形码',
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _query = value;
                    });
                  },
                ),
              ),
              Image.asset(
                AssetBundleUtils.getImgPath('shop_home_scan'),
                width: 16,
                height: 16,
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              _buildContentWidget(context, constraints)),
    );
  }

  Widget _buildContentWidget(BuildContext context, BoxConstraints constraints) {
    Widget? child = widget.builder?.call(context, constraints, _query);
    child ??= Container();
    return Container(constraints: constraints, child: child);
  }
}
