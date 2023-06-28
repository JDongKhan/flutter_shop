import 'package:flutter/material.dart';
import 'package:flutter_core/src/utils/asset_bundles_utils.dart';

///@author JD

enum IconTextAlignment {
  iconTopTextBottom, //图在上文字在下
  iconBottomTextTop, //图在下文字在上
  iconLeftTextRight, //图在左文字在右
  iconRightTextLeft, //图在右文字在左
}

///icon和text可以设定排版方向
class DirectionButton extends StatelessWidget {
  const DirectionButton({
    Key? key,
    this.onTap,
    this.icon,
    this.text,
    this.backgroundImage,
    this.width,
    this.height,
    this.middlePadding = 2.0,
    this.padding = const EdgeInsets.all(5),
    this.margin = const EdgeInsets.all(0),
    this.backgroundColor = Colors.transparent,
    this.alignment = IconTextAlignment.iconLeftTextRight,
  }) : super(key: key);

  final Widget? icon;
  final double middlePadding;
  final Function? onTap;
  final Text? text;
  final String? backgroundImage;
  final IconTextAlignment alignment;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget = icon;
    Widget? textWidget = text;

    double kpPadding = middlePadding;
    const double bPadding = 2;
    Widget? layoutWidget;
    List<Widget> childList = [];
    //图上文字下
    if (alignment == IconTextAlignment.iconTopTextBottom) {
      if (imageWidget != null) childList.add(imageWidget);
      if (text != null) {
        childList.add(Container(
          padding: EdgeInsets.only(
            left: 0,
            right: 0,
            top: kpPadding,
            bottom: bPadding,
          ),
          child: textWidget,
        ));
      }
      layoutWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: childList,
      );
    } else if (alignment == IconTextAlignment.iconBottomTextTop) {
      //图下文字上
      if (text != null) {
        childList.add(Container(
          padding: EdgeInsets.only(
            left: 0,
            right: 0,
            top: bPadding,
            bottom: kpPadding,
          ),
          child: textWidget,
        ));
      }
      if (imageWidget != null) childList.add(imageWidget);
      layoutWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: childList,
      );
    } else if (alignment == IconTextAlignment.iconLeftTextRight) {
      //图左文字右
      if (imageWidget != null) childList.add(imageWidget);
      if (text != null) {
        childList.add(Container(
          padding: EdgeInsets.only(
            left: kpPadding,
            right: bPadding,
            top: 0,
            bottom: 0,
          ),
          child: textWidget,
        ));
      }

      layoutWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: childList,
      );
    } else if (alignment == IconTextAlignment.iconRightTextLeft) {
      //图右文字左
      if (text != null) {
        childList.add(Container(
          padding: EdgeInsets.only(
            left: bPadding,
            right: kpPadding,
            top: 0,
            bottom: 0,
          ),
          child: textWidget,
        ));
      }
      if (imageWidget != null) childList.add(imageWidget);

      layoutWidget = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: childList,
      );
    }

    //背景颜色
    BoxDecoration? boxDecoration;
    if (backgroundImage != null) {
      boxDecoration = BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage(AssetBundleUtils.getImgPath(backgroundImage!)),
          fit: BoxFit.cover,
        ),
      );
    }

    layoutWidget = Container(
      width: width,
      height: height,
      color: backgroundColor,
      decoration: boxDecoration,
      padding: padding,
      margin: margin,
      child: layoutWidget,
    );
    if (onTap != null) {
      layoutWidget = InkWell(
        onTap: () {
          if (onTap != null) onTap?.call();
        },
        child: layoutWidget,
      );
    }

    return layoutWidget;
  }
}
