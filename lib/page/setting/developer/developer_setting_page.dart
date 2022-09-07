import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/controller/theme_controller.dart';
import '../../../style/styles.dart';

/// @author jd

class DeveloperSettingPage extends StatelessWidget {
  const DeveloperSettingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: const Text('开发者设置'),
      ),
      body: GetBuilder<ThemeController>(builder: (themeController) {
        return Column(
          children: [
            _buildItemWidget(
              '性能监控',
              themeController.showPerformanceOverlay,
              (value) {
                themeController.switchPerformanceOverlay(value);
              },
            ),
            _buildItemWidget(
              '检查缓存图片情况',
              themeController.checkerboardRasterCacheImages,
              (value) {
                themeController.switchCheckerboardRasterCacheImages(value);
              },
            ),
            _buildItemWidget(
              '检查不必要的saveLayer',
              themeController.checkerboardOffscreenLayers,
              (value) {
                themeController.switchCheckerboardOffscreenLayers(value);
              },
            ),
            _buildItemWidget(
              '显示边界布局',
              themeController.debugPaintSizeEnabled,
              (value) {
                themeController.switchDebugPaintSizeEnabled(value);
              },
            ),
            _buildItemWidget(
              '点击效果',
              themeController.debugPaintPointersEnabled,
              (value) {
                themeController.switchDebugPaintPointersEnabled(value);
              },
            ),
            _buildItemWidget(
              '显示边界',
              themeController.debugPaintLayerBordersEnabled,
              (value) {
                themeController.switchDebugPaintLayerBordersEnabled(value);
              },
            ),
            _buildItemWidget(
              '重绘时周边显示旋转色',
              themeController.debugRepaintRainbowEnabled,
              (value) {
                themeController.switchDebugRepaintRainbowEnabled(value);
              },
            ),
          ],
        );
      }),
    );
  }

  Widget _buildItemWidget(
      String title, bool value, ValueChanged<bool> changed) {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Text(title),
        const SizedBox(
          width: 20,
        ),
        Switch(
            value: value,
            onChanged: (value) {
              if (changed != null) {
                changed(value);
              }
            }),
      ],
    );
  }
}
