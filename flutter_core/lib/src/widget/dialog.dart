import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 这里放一些快速使用的弹框方法
/// 显示actionSheet
void showActionSheet({
  required BuildContext context,
  required String title,
  required String message,
  required List<Widget>? actions,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return CupertinoActionSheet(
        title: Text(title),
        message: Text(message),
        actions: actions,
      );
    },
  );
}

Future showCustomDialog({
  required BuildContext context,
  required WidgetBuilder builder,
  ValueChanged<BuildContext>? okAction,
  ValueChanged<BuildContext>? cancelAction,
  BoxDecoration? decoration,
}) {
  return showCupertinoModalPopup<int?>(
    context: context,
    // shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadiusDirectional.circular(10)),
    builder: (BuildContext context) {
      return Container(
        decoration: decoration ??
            BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buttonWidget(
                    title: '取消',
                    textColor: Colors.black38,
                    callback: () {
                      if (cancelAction != null) {
                        cancelAction.call(context);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  _buttonWidget(
                    title: '确定',
                    textColor: Colors.black,
                    callback: () {
                      if (okAction != null) {
                        okAction.call(context);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
              builder.call(context),
            ],
          ),
        ),
      );
    },
  );
}

//公共button
Widget _buttonWidget(
    {String? title, Color? textColor, VoidCallback? callback}) {
  return TextButton(
    onPressed: () {
      callback?.call();
    },
    child: Text(
      title ?? '',
      style: TextStyle(
        color: textColor,
        fontSize: 14,
      ),
    ),
  );
}

showBottomDialog({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return builder.call(context);
    },
  );
}

Future showAlertDialog({
  required BuildContext context,
  String? title,
  String? message,
  ValueChanged<BuildContext>? cancelAction,
  ValueChanged<BuildContext>? okAction,
  String? leftBtn,
  String? rightBtn,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title != null ? Text(title) : null,
        content: message != null ? Text(message) : null,
        actions: <Widget>[
          TextButton(
            child: Text(leftBtn ?? '取消'),
            onPressed: () {
              if (cancelAction != null) {
                cancelAction.call(context);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          TextButton(
            child: Text(rightBtn ?? '确定'),
            onPressed: () {
              if (okAction != null) {
                okAction.call(context);
              } else {
                Navigator.of(context).pop();
              }
            },
          )
        ],
      );
    },
  );
}
