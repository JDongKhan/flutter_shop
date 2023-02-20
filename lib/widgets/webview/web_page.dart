import 'package:flutter/material.dart';
import 'src/widget/web_view_for_platform.dart';
import 'web_view.dart';

/// @author jd

///web page
class WebPage extends StatefulWidget {
  const WebPage(
      {super.key, required this.url, this.title, this.hideAppBar = false});
  final String? title;
  final String url;
  final bool hideAppBar;
  @override
  State createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  String? _title;
  final WebViewProgressController _controller = WebViewProgressController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? leftWidget = null;
    if (Navigator.canPop(context)) {
      leftWidget = _buildAppBarLeft();
    }
    return Container(
      color: Colors.white,
      child: NotificationListener<WebViewNotification>(
        onNotification: (WebViewNotification notification) {
          if (notification is WebViewPageStartedNotification) {
            _controller.show();
          } else if (notification is WebViewPageFinishedNotification) {
            if (widget.title == null && notification.title != null) {
              setState(() {
                _title = notification.title ?? '';
              });
            }
            _controller.dismiss();
          } else if (notification is WebViewWebResourceErrorNotification) {
            _controller.dismiss();
          }
          return true;
        },
        child: Column(
          children: [
            //appbar
            if (!widget.hideAppBar)
              _commonAppBar(
                title: _title ?? widget.title ?? '',
                leftWidget: leftWidget,
              ),
            WebViewProgress(
              controller: _controller,
            ),
            Expanded(
              child: WebView(
                url: widget.url,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///通用APP bar 统一后退键
  Widget _buildAppBarLeft() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        // color: Colors.red,
        padding: const EdgeInsets.only(left: 20, right: 0),
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.arrow_back_ios,
        ),
      ),
    );
  }

  Widget _commonAppBar({
    Widget? leftWidget,
    String? title,
    List<Widget>? rightWidget,
    Color bgColor = Colors.white,
  }) {
    return Container(
      color: bgColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 44,
          // color: Colors.blue,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              leftWidget ?? Container(),
              Expanded(
                child: Text(
                  '$title',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              if (rightWidget != null) ...rightWidget,
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewProgressController extends ChangeNotifier {
  double progress = 0.0;
  bool _show = false;

  void updateProgress(double progress) {
    this.progress = progress;
    notifyListeners();
  }

  void show() {
    _show = true;
    notifyListeners();
  }

  void dismiss() {
    _show = false;
    notifyListeners();
  }
}

class WebViewProgress extends StatefulWidget {
  final WebViewProgressController? controller;
  const WebViewProgress({super.key, this.controller});
  @override
  State createState() => _WebViewProgressState();
}

class _WebViewProgressState extends State<WebViewProgress> {
  @override
  void initState() {
    widget.controller?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.controller?._show ?? false,
      child: LinearProgressIndicator(
        // value: widget.account.progress,
        backgroundColor: Colors.grey[100],
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[100]!),
      ),
    );
  }
}
