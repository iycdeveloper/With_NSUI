import 'package:flutter/material.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/view_model/payment/payment_screen_vm.dart';

class PaymentScreen extends StatefulWidget {
  final String transactionId;
  final String amount;
  final String source;
  final bool isYIKBPayment;

  const PaymentScreen({
    Key? key,
    required this.transactionId,
    required this.amount,
    required this.source,
    this.isYIKBPayment = false,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initWebViewController();
  }

  void _initWebViewController() {
    final paymentUrl =
        "${widget.source == "LC" ? "https://api.iyc.in/ycea/ycea-api/service/nsui/api/v1.0/legalCell/initiateLegalCellPayment.php?" : "https://api.iyc.in/ycea/ycea-api/service/nsui/api/v1.0/aggregator/ccavenue/initiateAggrPayment.php?"}SOURCE=${widget.source}&ORDER_NUMBER=${widget.transactionId}&AMOUNT=1&ORG=NSUI"; //${widget.amount}
    print(paymentUrl);
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;
            print("Intercepted URL: $url");

            // 🔥 Handle all payment deep links (Android + iOS)
            if (url.startsWith("upi://") ||
                url.startsWith("phonepe://") ||
                url.startsWith("paytmmp://") ||
                url.startsWith("tez://") ||
                url.startsWith("intent://")) {
              try {
                // 🔥 Handle intent:// (Android special case)
                if (url.startsWith("intent://")) {
                  final intentUrl = Uri.parse(url);

                  await launchUrl(
                    intentUrl,
                    mode: LaunchMode.externalApplication,
                  );
                } else {
                  final uri = Uri.parse(url);

                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                }
              } catch (e) {
                print("Payment app launch error: $e");
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            if (url.contains("/ccavResponseHandler.php") ||
                url.contains("/yikbPaymentHandler.php")) {
              _controller.runJavaScript(
                  "ProcessHTML.postMessage(document.getElementsByTagName('html')[0].innerHTML)");
            }
          },
        ),
      )
      //TODO
      ..addJavaScriptChannel(
        'ProcessHTML',
        // JavaScriptChannel(
        //   name: 'ProcessHTML',
        //   onMessageReceived: (JavascriptMessage message) {
        //     TransactionStatus transactionStatus = _determineTransactionStatus(message.message);
        //     Navigator.of(context).pop(transactionStatus);
        //   },
        // ),
        onMessageReceived: (JavaScriptMessage p1) {
          TransactionStatus transactionStatus =
              _determineTransactionStatus(p1.message);
          Navigator.of(context).pop(transactionStatus);
        },
      )
      ..loadRequest(Uri.parse(paymentUrl));
    print(paymentUrl);
  }

  TransactionStatus _determineTransactionStatus(String html) {
    if (html.contains("Failure")) return TransactionStatus.declined;
    if (html.contains("Success")) return TransactionStatus.success;
    if (html.contains("Aborted")) return TransactionStatus.cancelled;
    return TransactionStatus.unknown;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(TransactionStatus.unknown);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<PaymentScreenVM>(
            builder: (_, __, ___) => WebViewWidget(
              controller: _controller,
            ),
          ),
        ),
      ),
    );
  }
}

enum TransactionStatus { declined, success, cancelled, unknown }
