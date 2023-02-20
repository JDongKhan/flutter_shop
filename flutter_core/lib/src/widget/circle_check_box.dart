import 'package:flutter/material.dart';
import 'package:flutter_core/src/utils/asset_bundles_utils.dart';

/// @author jd

///圆形checkbox，自定义样式的checkbox
class CircleCheckBox extends StatelessWidget {
  const CircleCheckBox({
    Key? key,
    this.value = false,
    this.tapSize = const Size(18, 18),
    this.middlePadding = 6,
    this.text,
    required this.checkedWidget,
    required this.unCheckWidget,
    required this.onChanged,
  }) : super(key: key);
  //是否选中
  final bool value;
  //可点击范围
  final Size tapSize;
  //文字和图标间隔
  final double middlePadding;
  //文字
  final Widget? text;
  //改变事件
  final ValueChanged<bool> onChanged;
  //选中的widget
  final Widget checkedWidget;
  //未选中的widget
  final Widget unCheckWidget;

  CircleCheckBox.icon({
    Key? key,
    bool value = false,
    Color checkColor = Colors.blue,
    Color unCheckColor = Colors.grey,
    required ValueChanged<bool> onChanged,
  }) : this(
          key: key,
          onChanged: onChanged,
          value: value,
          checkedWidget: Icon(
            Icons.check_circle,
            color: checkColor,
          ),
          unCheckWidget: Icon(
            Icons.radio_button_unchecked_outlined,
            color: unCheckColor,
          ),
        );

  CircleCheckBox.image({
    Key? key,
    bool value = false,
    Image? checkImage,
    Image? unCheckImage,
    required ValueChanged<bool> onChanged,
  }) : this(
          key: key,
          onChanged: onChanged,
          value: value,
          checkedWidget: checkImage ??
              Image.asset(
                AssetBundleUtils.getImgPath('checked'),
                package: 'flutter_core',
              ),
          unCheckWidget: unCheckImage ??
              Image.asset(
                AssetBundleUtils.getImgPath('unchecked'),
                package: 'flutter_core',
              ),
        );

  @override
  Widget build(BuildContext context) {
    Widget child;
    Widget iconWidget = Container(
      width: tapSize.width,
      height: tapSize.height,
      alignment: Alignment.centerLeft,
      // color: Colors.red,
      child: value ? checkedWidget : unCheckWidget,
    );
    if (text != null) {
      child = Row(
        children: [
          iconWidget,
          SizedBox(width: middlePadding),
          text!,
        ],
      );
    } else {
      child = iconWidget;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onChanged(!value);
      },
      child: child,
    );
  }
}
