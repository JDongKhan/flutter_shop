import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../web_view_adapter.dart';
import '../widget/web_view_for_platform.dart';

/// @author jd

WebViewAdapter createAdapter() => IOAdapter();

class IOAdapter implements WebViewAdapter {
  @override
  Widget createWebView(String url) {
    return WebViewForPlatform(
      url: url,
    );
  }
}
