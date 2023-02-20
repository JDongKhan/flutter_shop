import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewForPlatform extends StatefulWidget {
  final String url;
  final String? title;

  WebViewForPlatform({super.key, required this.url, this.title});

  @override
  State<WebViewForPlatform> createState() => _WebViewForPlatformState();
}

class _WebViewForPlatformState extends State<WebViewForPlatform> {
  late WebViewController _webViewController;

  @override
  void initState() {
    final bool isRemote =
        widget.url.startsWith('http') || widget.url.startsWith('https');
    bool isLocal = !isRemote;
    String localUrl = '';
    if (isRemote) {
      localUrl = widget.url;
    } else {
      if (Platform.isAndroid) {
        localUrl = '/android_asset/flutter_assets/${widget.url}';
      } else {
        localUrl = '/Frameworks/App.framework/flutter_assets/${widget.url}';
      }
    }

    //初始化controller
    _webViewController = WebViewController();
    _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    _webViewController.setBackgroundColor(const Color(0x00000000));
    _webViewController.setNavigationDelegate(
      NavigationDelegate(
        //进度
        onProgress: (int progress) {
          // Update loading bar.
        },
        //页面开始
        onPageStarted: (String url) {
          WebViewPageStartedNotification(url).dispatch(context);
          debugPrint('onPageStarted:$url');
        },
        //页面请求结束
        onPageFinished: (String url) {
          debugPrint('onPageFinished:$url');
          _webViewController
              .runJavaScriptReturningResult('document.title')
              .then(
                (value) => {
                  WebViewPageFinishedNotification(
                          controller: _webViewController,
                          url: url,
                          title: value.toString())
                      .dispatch(context)
                },
              );
        },
        //资源请求错误
        onWebResourceError: (WebResourceError error) {
          debugPrint('onWebResourceError:$error');
          WebViewWebResourceErrorNotification(error.toString())
              .dispatch(context);
        },
        //请求拦截
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    if (isLocal) {
      // _loadHtmlAssets()
      //     .then((value) => {_webViewController.loadRequest(value)});
      _webViewController.loadFile(localUrl);
    } else {
      Map<String, String> header = {};
      header['Cookie'] = 'Authorization=23222;';
      _webViewController.loadRequest(Uri.parse(localUrl), headers: header);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _webViewController,
    );
  }

  Future<Uri> _loadHtmlAssets() async {
    String htmlPath = await rootBundle.loadString(widget.url);
    return Uri.dataFromString(
      htmlPath,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    );
  }
}

class WebViewNotification extends Notification {}

class WebViewPageStartedNotification extends WebViewNotification {
  final String url;
  WebViewPageStartedNotification(this.url);
}

class WebViewPageFinishedNotification extends WebViewNotification {
  final String url;
  final String? title;
  final WebViewController controller;
  WebViewPageFinishedNotification(
      {required this.controller, required this.url, this.title});
}

class WebViewWebResourceErrorNotification extends WebViewNotification {
  final String error;
  WebViewWebResourceErrorNotification(this.error);
}
