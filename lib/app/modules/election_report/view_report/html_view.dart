import 'dart:io';

import 'package:flutter/material.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as html_to_pdf;
import 'package:iyc/app/core/utils/progress_dialog_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';

class HtmlViewer extends StatefulWidget {
  final String htmlContent;

  const HtmlViewer({Key? key, required this.htmlContent}) : super(key: key);

  @override
  State<HtmlViewer> createState() => _HtmlViewerState();
}

class _HtmlViewerState extends State<HtmlViewer> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadHtmlString(widget.htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            leadingWidth: 44.h,
            leading: AppbarImage(
                onTap: Get.back,
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
            title:
                AppbarSubtitle1(text: '', margin: EdgeInsets.only(left: 12.h)),
            actions: [
              IconButton(
                  onPressed: () async {
                    ProgressDialogUtils.showProgressIndicator();
                    var filePath = 'test/output.pdf';
                    var file = File(filePath);
                    final newPdf = html_to_pdf.Document();
                    List<html_to_pdf.Widget> widgets =
                        await html_to_pdf.HTMLToPdf().convert(
                      widget.htmlContent,
                    );
                    newPdf.addPage(html_to_pdf.MultiPage(
                        maxPages: 200,

                        build: (context) {
                          return widgets;
                        }));
                    await file.writeAsBytes(await newPdf.save(), );

                    ProgressDialogUtils.closeDialog();
                    await Share.shareXFiles([XFile(file.path)],
                        text: 'Here is your generated PDF!');
                  },
                  icon: const Icon(
                    Icons.share,
                    size: 30,
                    color: Colors.lightBlueAccent,
                  ))
            ],
            styleType: Style.standard),
        body: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
