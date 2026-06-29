import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ShareTaskWebView extends StatefulWidget {
  const ShareTaskWebView({Key? key}) : super(key: key);

  @override
  State<ShareTaskWebView> createState() => _ShareTaskWebViewState();
}

class _ShareTaskWebViewState extends State<ShareTaskWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            url: WebUri(
                "https://www.facebook.com/sharer/sharer.php?u=https://stackoverflow.com/questions/22652041/how-to-pass-a-parameter-like-title-summary-and-image-in-a-facebook-sharer-url&name"
                "=abcde")),
        onWebViewCreated: (controller) async {},
        onLoadStop: (cont, uri) {
          print(uri?.path);
          if (uri?.path == "/dialog/close_window/") Navigator.of(context).pop();
        },
      ),
    );
  }
}
