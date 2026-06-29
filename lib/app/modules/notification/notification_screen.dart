import 'package:flutter/material.dart';
import 'package:iyc/app/modules/Home/home_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image.dart';
import 'package:iyc/app/widgets/app_bar/appbar_subtitle_1.dart';
import 'package:iyc/app/widgets/app_bar/custom_app_bar.dart';

import '../../core/app_export.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
            leadingWidth: 44.h,
            leading: AppbarImage(
                onTap: () {
                  // Get.back();
                  Get.find<HomeController>().changeSelectIndex();
                  Get.back();
                },
                svgPath: ImageConstant.imgBiarrowleftIndigo800,
                margin: EdgeInsets.only(left: 20.h, top: 15.v, bottom: 15.v)),
            title: AppbarSubtitle1(
                text: "Notification", margin: EdgeInsets.only(left: 12.h)),
            styleType: Style.standard),
        body: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Center(
            child: Text(
              'No Notification Found',
              style: CustomTextStyles.titleMedium18.copyWith(
                color: appTheme.indigo800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
