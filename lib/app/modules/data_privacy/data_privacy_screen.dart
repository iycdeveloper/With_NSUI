import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';

import '../../core/app_export.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class DataPrivacyPolicy extends StatelessWidget {
  const DataPrivacyPolicy({Key? key})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          leadingWidth: 44.h,
          leading: AppbarImage(
            onTap: Get.back,
            svgPath: ImageConstant.imgBiarrowleftIndigo800,
            margin: EdgeInsets.only(
              left: 20.h,
              top: 15.v,
              bottom: 15.v,
            ),
          ),
          title: AppbarSubtitle1(
            text: "Privacy Policy",
            margin: EdgeInsets.only(left: 12.h),
          ),
          styleType: Style.standard,
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri("https://iyc.in/privacy.html"),
          ),
        ),
      ),
    );
  }
}