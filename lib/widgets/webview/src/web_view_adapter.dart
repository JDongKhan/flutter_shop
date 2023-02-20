import 'package:flutter/material.dart';
import 'adapter/create_adapter.dart'
    if (dart.library.html) 'adapter/web_view_browser_adapter.dart'
    if (dart.library.io) 'adapter/web_view_io_adapter.dart';

WebViewAdapter webViewPlatformAdapter = createAdapter();

abstract class WebViewAdapter {
  Widget createWebView(String url);
}
