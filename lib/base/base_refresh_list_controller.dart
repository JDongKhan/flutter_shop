import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';

import 'base_list_controller.dart';

/// 带有刷新逻辑的controller
abstract class BaseRefreshListController<E> extends BaseListController<E> {
  BaseRefreshListController({
    super.autoUpdate = true,
    super.immediatelyInit = true,
  });

  int currentPage = 0;
  int pages = 0;
  int pageSize = 20;

  //刷新逻辑

  ///刷新
  Future<IndicatorResult> onRefresh() async {
    currentPage = 0;
    // monitor src.network fetch
    debugPrint('下拉刷新开始...');
    List<E>? list = await loadData();
    debugPrint('加载数据完成...');
    super.data.clear();
    addAll(list);
    debugPrint('下拉刷新结束...');
    IndicatorResult result = IndicatorResult.success;
    if (list == null || list.isEmpty) {
      setNoData();
    } else if (list.length < pageSize) {
      result = IndicatorResult.noMore;
    }
    if (autoUpdate) {
      update();
    }
    return result;
  }

  ///加载更多
  Future<IndicatorResult> onLoad() async {
    currentPage++;
    debugPrint('上拉刷新开始...');
    List<E>? list = await loadData();
    debugPrint('加载数据完成...');
    addAll(list);
    IndicatorResult result = IndicatorResult.success;
    if (list == null || list.length < pageSize) {
      result = IndicatorResult.noMore;
    }
    debugPrint('上拉刷新结束...');
    if (autoUpdate) {
      update();
    }
    return result;
  }
}
