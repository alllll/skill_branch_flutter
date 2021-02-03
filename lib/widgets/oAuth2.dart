import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OAuth2 extends StatefulWidget {
  String initialUrl;
  String clienId;
  String clientSecret;
  String redirectUri;
  Function onAuth;
  bool clearCookies;

  OAuth2(this.initialUrl, this.clienId, this.clientSecret, this.redirectUri,
      this.onAuth, this.clearCookies);

  @override
  State<OAuth2> createState() {
    return _OAuth2State();
  }
}

class _OAuth2State extends State<OAuth2> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final CookieManager _cookieManager = new CookieManager();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.clearCookies) {
      return FutureBuilder<bool>(
        future: _cookieManager.clearCookies(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _createWebView();
          }
        },
      );
    } else
      return _createWebView();
  }

  Widget _createWebView() {
    return WebView(
      initialUrl: widget.initialUrl +
          "?client_id=" +
          widget.clienId +
          "&redirect_uri=" +
          widget.redirectUri +
          "&response_type=code&scope=public+read_user+write_user+read_photos+write_photos+write_likes+write_followers+read_collections+write_collections",
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
      },
      navigationDelegate: (NavigationRequest request) async {
        if (request.url.startsWith('https://alllll.ru/')) {
          var uri = Uri.parse(request.url);
          print(request.url);
          // String code = request.url.substring(widget.redirectUri.length + 5);
          print(uri.queryParameters["code"]);
          _getToken(uri.queryParameters["code"]);
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
    );
  }

  void _getToken(String code) async {
    var dio = Dio();
    Response resp =
        await dio.post("https://unsplash.com/oauth/token", queryParameters: {
      "client_id": widget.clienId,
      "client_secret": widget.clientSecret,
      "redirect_uri": widget.redirectUri,
      "code": code,
      "grant_type": "authorization_code"
    });
    var token = resp.data["access_token"];
    widget.onAuth(token);
  }
}
