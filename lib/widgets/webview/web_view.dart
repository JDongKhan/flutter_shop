import 'package:flutter/widgets.dart';

import 'src/web_view_adapter.dart';

class WebView extends StatelessWidget {
  final String url;
  const WebView({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return webViewPlatformAdapter.createWebView(url);
  }
}
