import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'skeleton/article_skeleton.dart';
import 'skeleton/skeleton.dart';

enum LoadingStyle {
  list,
  detail,
  none,
}

///@author JD

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    this.loadingStyle = LoadingStyle.list,
  }) : super(key: key);
  final LoadingStyle loadingStyle;
  @override
  Widget build(BuildContext context) {
    if (loadingStyle == LoadingStyle.list) {
      return SkeletonList(
        builder: (c, idx) => const ArticleSkeletonItem(),
      );
    }
    if (loadingStyle == LoadingStyle.detail) {
      return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: const CupertinoActivityIndicator(
          radius: 14,
        ),
      );
    }
    return Container();
  }
}
