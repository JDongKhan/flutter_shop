import 'package:flutter/material.dart';
import 'package:flutter_core/src/utils/asset_bundles_utils.dart';

///@author JD
class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({
    Key? key,
    this.onRetry,
    this.error = '请求失败，点击重试',
    this.child,
    this.errorImage = 'default_error',
    this.actionTitle = '重试',
  }) : super(key: key);
  final String errorImage;
  final Function? onRetry;
  final String error;
  final String actionTitle;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    Widget errorWidget = Text(
      error,
      style: const TextStyle(color: Color(0xff686E7E), fontSize: 14),
    );
    if (child != null) {
      errorWidget = child!;
    }
    return Container(
      alignment: const Alignment(0, -0.3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AssetBundleUtils.getImgPath(errorImage),
            width: 150,
            height: 150,
          ),
          const SizedBox(
            height: 11,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: errorWidget,
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              onRetry?.call();
            },
            style: TextButton.styleFrom(
              padding:
                  const EdgeInsets.only(top: 7, bottom: 7, left: 30, right: 30),
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.white,
              textStyle: const TextStyle(
                fontSize: 16,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
            ),
            child: Text(
              actionTitle,
            ),
          ),
        ],
      ),
    );
  }
}
