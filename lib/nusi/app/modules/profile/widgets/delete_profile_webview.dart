import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/image_constant.dart';
import 'package:iyc/app/theme/theme_helper.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(
          "https://docs.google.com/forms/d/e/1FAIpQLSdKVVUhtOjima6uF2hd8db2t8zXj_tVtMAFPuNTc6obzeQTYw/viewform"));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Account Deletion Form',
              style: theme.textTheme.titleLarge!.copyWith(
                  color: appTheme.indigo800, fontWeight: FontWeight.bold)),
          elevation: 0,
          leading: AppbarImage(
              onTap: () {
                Get.back();
              },
              svgPath: ImageConstant.imgBiarrowleftIndigo800,
              margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
