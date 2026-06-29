import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';

class ScrutinyScreen extends StatelessWidget {
  const ScrutinyScreen();

  @override
  Widget build(BuildContext context) {
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
            text: "Scrutiny",
            margin: EdgeInsets.only(left: 12.h),
          ),
          styleType: Style.standard,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 20),
          child: Column(
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
