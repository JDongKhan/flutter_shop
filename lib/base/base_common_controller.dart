import 'package:flutter_core/flutter_core.dart';
import 'package:get/get.dart';
import 'base_controller.dart';

/// 通用的，都可以用
abstract class BaseCommonController<T> extends BaseController {
  BaseCommonController({
    super.autoUpdate = true,
    super.immediatelyInit = true,
  });

  List<Function> onInitDataFinishList = [];
  // ignore: prefer_typing_uninitialized_variables
  final Rx<T?> _data = Rx(null);
  T? get data => _data.value;
  set data(value) {
    _data.value = value;
    if (value == null || ObjectUtils.isEmpty(value)) {
      setNoData();
    } else {
      setSuccess();
    }
  }

  @override
  Future<T?> initData() {
    setLoading();
    return loadData().then((value) {
      T v = value;
      data = value;
      onInitDataFinish();
      return v;
    }).catchError((error, stackTrace) {
      logger.w('${error.toString()}\n${stackTrace.toString()}');
      setFailed(error);
    });
  }

  //初始化数据完成
  void onInitDataFinish() {
    for (var element in onInitDataFinishList) {
      element.call();
    }
  }

  void addInitDataFinish(Function listener) {
    onInitDataFinishList.add(listener);
  }

  void refreshState() {
    _data.refresh();
  }
}
