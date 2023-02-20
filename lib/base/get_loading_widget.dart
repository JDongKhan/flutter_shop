import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:get/get.dart';

import '../widgets/loading_widget.dart';
import 'base_controller.dart';

///@author JD

class GetXLoadingWidget<T extends BaseController> extends StatelessWidget {
  const GetXLoadingWidget({
    Key? key,
    this.loadingStyle = LoadingStyle.list,
    required this.builder,
    this.assignId = false,
    this.tag,
    this.init,
  }) : super(key: key);
  final LoadingStyle loadingStyle;
  final GetControllerBuilder<T> builder;
  final String? tag;
  final T? init;
  final bool assignId;
  @override
  Widget build(BuildContext context) {
    return GetX<T>(
      tag: tag,
      init: init,
      assignId: assignId,
      builder: (controller) => _buildWidget(controller),
    );
  }

  Widget _buildWidget(T controller) {
    LoadingStatus loadingStatus = controller.loadingStatus;

    /// 初始化状态
    if (loadingStatus == LoadingStatus.idle) {
      return Container();
    }

    /// 无数据状态
    if (loadingStatus == LoadingStatus.noData) {
      return LoadingErrorWidget(
        error: '暂无数据',
        errorImage: 'car2_buy_empty',
        actionTitle: '重试',
        onRetry: () {
          controller.initData();
        },
      );
    }

    /// 请求失败
    if (loadingStatus == LoadingStatus.failed) {
      return LoadingErrorWidget(
        error: controller.error ?? '错误信息为空',
        onRetry: () {
          controller.initData();
        },
      );
    }

    /// 加载中
    if (loadingStatus == LoadingStatus.loading) {
      return LoadingWidget(
        loadingStyle: loadingStyle,
      );
    }

    /// 请求成功
    return builder(controller);
  }
}

class GetBuilderLoadingWidget<T extends BaseController>
    extends StatelessWidget {
  const GetBuilderLoadingWidget({
    Key? key,
    this.loadingStyle = LoadingStyle.list,
    required this.builder,
    this.assignId = false,
    this.errorBuilder,
    this.tag,
    this.init,
  }) : super(key: key);
  final LoadingStyle loadingStyle;
  final GetControllerBuilder<T> builder;
  final GetControllerBuilder<T>? errorBuilder;
  final String? tag;
  final bool assignId;
  final T? init;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: init,
      assignId: assignId,
      tag: tag,
      builder: (controller) => _buildWidget(controller),
    );
  }

  Widget _buildWidget(T controller) {
    LoadingStatus loadingStatus = controller.loadingStatus;

    // 成功
    if (loadingStatus == LoadingStatus.success) {
      return builder(controller);
    }
    // 错误
    Widget? errorWidget = errorBuilder?.call(controller);
    if (errorWidget != null) {
      return errorWidget;
    }

    /// 初始化状态
    if (loadingStatus == LoadingStatus.idle) {
      return Container();
    }

    /// 无数据状态
    if (loadingStatus == LoadingStatus.noData) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetBundleUtils.getImgPath('default_error'),
              width: 150,
              height: 150,
            ),
            const Text('暂无数据'),
            const SizedBox(
              height: 5,
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  side: BorderSide(color: Colors.blue),
                ),
              ),
              onPressed: () {
                controller.initData();
              },
              child: const Text(
                '重试',
              ),
            ),
          ],
        ),
      );
    }

    /// 请求失败
    if (loadingStatus == LoadingStatus.failed) {
      return LoadingErrorWidget(
        error: controller.error.toString(),
        onRetry: () {
          controller.initData();
        },
      );
    }

    /// 加载中
    if (loadingStatus == LoadingStatus.loading) {
      return LoadingWidget(
        loadingStyle: loadingStyle,
      );
    }

    /// 请求成功
    return builder(controller);
  }
}
