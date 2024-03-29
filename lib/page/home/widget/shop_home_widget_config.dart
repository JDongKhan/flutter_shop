import 'package:flutter/material.dart';
import 'package:flutter_core/flutter_core.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

import '../../../widgets/privacy_widget.dart';
import '../../../widgets/webview/web_page.dart';

/// @author jd

///下拉刷新
Widget buildPulltoRefreshImage(
    BuildContext context, PullToRefreshScrollNotificationInfo? info) {
  var offset = 0.0;
  if (info != null && info.dragOffset != null) {
    offset = info.dragOffset ?? 0;
  }
  Widget refreshWidget = Container();
  if (info != null && info.refreshWidget != null && offset > 100) {
    refreshWidget = info.refreshWidget!;
  }

  String mode = '下拉刷新';
  if (info != null && info.mode != null) {
    PullToRefreshIndicatorMode modeEnum = info.mode!;
    switch (modeEnum) {
      case PullToRefreshIndicatorMode.refresh:
        mode = '刷新中...';
        break;
      case PullToRefreshIndicatorMode.done:
        mode = '刷新成功';
        break;
      case PullToRefreshIndicatorMode.canceled:
        mode = '刷新取消';
        break;
      case PullToRefreshIndicatorMode.error:
        mode = '刷新错误';
        break;
    }
  }
  print('pull-offset:$offset');
  return SliverToBoxAdapter(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: offset,
          width: double.infinity,
          child: Image.asset(
            AssetBundleUtils.getImgPath('meinv2'),
            fit: BoxFit.fitWidth,
          ),
        ),
        Container(
          height: offset,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              refreshWidget,
              Container(
                padding: const EdgeInsets.only(left: 5.0),
                alignment: Alignment.center,
                child: Text(
                  mode,
                  style: const TextStyle(
                    fontSize: 12,
                    inherit: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

///显示隐私弹框  来源：copy外部
void showPrivacyView(BuildContext context, String message) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: '',
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Material(
            child: Container(
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width * .8,
              child: Column(
                children: [
                  Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: const Text(
                      '用户隐私政策概要',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: PrivacyWidget(
                        data: message,
                        keys: const <String>[
                          '《用户协议》',
                          '《隐私政策》',
                        ],
                        keyStyle: const TextStyle(color: Colors.red),
                        onTapCallback: (String key) {
                          if (key == '《用户协议》') {
                            Navigator.of(context).push(
                              MaterialPageRoute<WebPage>(
                                builder: (BuildContext context) {
                                  return WebPage(
                                      title: key, url: 'https://flutter.dev');
                                },
                              ),
                            );
                          } else if (key == '《隐私政策》') {
                            Navigator.of(context).push(
                              MaterialPageRoute<WebPage>(
                                builder: (BuildContext context) {
                                  return WebPage(
                                      title: key, url: 'https://www.baidu.com');
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )),
                  const Divider(
                    height: 1,
                  ),
                  Container(
                    height: 45,
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text('不同意'),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const VerticalDivider(
                          width: 1,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.blue[100],
                              child: const Text('同意'),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
