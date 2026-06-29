import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SocialNSUIController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initmethod();
  }

  String? selectSocialMedia = 'X';
  List<DropdownItem>? listValues = [
    // DropdownItem('Facebook', 'Facebook'),
    DropdownItem('Instagram', 'Instagram'),
    DropdownItem('X', 'X'),
  ];
  WebViewController? webviewcontroller;

  void initWebViewController(String url) {
    webviewcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains("facebook")) {
              webviewcontroller!.runJavaScript(
                  "ProcessHTML.postMessage(document.getElementsByTagName('html')[0].innerHTML)");
            }
          },
        ),
      )
      ..loadRequest(Uri.parse('$url'));

    update();
  }

  onchangeSocialMedia(String value) {
    selectSocialMedia = value;
    update();

    switch (selectSocialMedia) {
      case 'Facebook':
        initWebViewController('https://www.facebook.com/nsui.in');
        break;
      case 'Instagram':
        initWebViewController('https://www.instagram.com/nsui_india/?hl=en');
        break;
      case 'X':
        initWebViewController(
            'https://x.com/nsui?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor');
        break;
    }
    // update();
  }

  initmethod() async {
    await Future.delayed(const Duration(seconds: 2));
    onchangeSocialMedia('X');
  }
}
