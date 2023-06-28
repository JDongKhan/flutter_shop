import 'dart:async';

import 'package:flutter/material.dart';

class DialogQueue {
  // 请求队列
  final List<DialogElement> _dialogQueue = [];
  // 构建单例
  static final DialogQueue _instance = DialogQueue._();
  static DialogQueue get instance => _instance;
  DialogQueue._();

  // 是否正在显示
  bool _isShowing = false;
  @protected
  bool get isShowing => _isShowing;

  Future<T?> showDialog<T extends Object?>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? label,
  }) async {
    Completer<T> completer = Completer();
    DialogElement dialogElement = DialogElement(
      context: context,
      completer: completer,
      builder: builder,
      label: label,
    );
    _dialogQueue.add(dialogElement);
    _showNext();
    return completer.future;
  }

  _sortQueue() {
    if (_dialogQueue.length <= 1) {
      return;
    }
    _dialogQueue.sort((a, b) {
      if (a.priority > b.priority) {
        return -1;
      } else if (a.priority < b.priority) {
        return 1;
      }
      return 0;
    });
  }

  void _showNext() async {
    if (_isShowing) {
      return null;
    }
    //先排序
    _sortQueue();
    if (!_isShowing && _dialogQueue.isNotEmpty) {
      _isShowing = true;
      DialogElement nextDialog = _dialogQueue.first;
      _dialogQueue.remove(nextDialog);
      dynamic obj = await _showDialog(nextDialog);
      nextDialog.completer?.complete(obj);
      _showNext();
      _isShowing = false;
    }
  }

  Future<T?> _showDialog<T extends Object?>(DialogElement dialogElement) {
    if (!dialogElement.context.mounted) {
      return Future(() => null);
    }
    return showGeneralDialog<T>(
      context: dialogElement.context,
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          child: dialogElement.builder(context),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: child,
          ),
        );
      },
    );
  }
}

const defaultPriority = 0;

class DialogElement {
  final int priority;
  String? label;
  final BuildContext context;
  final WidgetBuilder builder;
  final Completer? completer;
  DialogElement({
    required this.context,
    required this.builder,
    this.priority = defaultPriority,
    this.label,
    this.completer,
  });
}
