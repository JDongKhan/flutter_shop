import 'package:flutter/material.dart';

///@Description TODO
///@Author jd

// 空水纹实现工厂
class NoSplashFactory extends InteractiveInkFeatureFactory {
  @override
  InteractiveInkFeature create(
      {required MaterialInkController controller,
      required RenderBox referenceBox,
      required Offset position,
      required Color color,
      required TextDirection textDirection,
      bool containedInkWell = false,
      RectCallback? rectCallback,
      BorderRadius? borderRadius,
      ShapeBorder? customBorder,
      double? radius,
      VoidCallback? onRemoved}) {
    return _NoInteractiveInkFeature(
        controller: controller,
        referenceBox: referenceBox,
        color: color,
        onRemoved: onRemoved);
  }
}

// // InkFeature空实现
class _NoInteractiveInkFeature extends InteractiveInkFeature {
  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
  _NoInteractiveInkFeature({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Color color,
    VoidCallback? onRemoved,
  }) : super(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved);
}
