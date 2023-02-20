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

showAlertDialog({
  required BuildContext context,
  String? title,
  String? message,
  Function? cancelAction,
  Function? okAction,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: message != null ? Text(message) : null,
        actions: <Widget>[
          TextButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop();
              cancelAction?.call();
            },
          ),
          TextButton(
            child: const Text('确定'),
            onPressed: () {
              Navigator.of(context).pop();
              okAction?.call();
            },
          )
        ],
      );
    },
  );
}
