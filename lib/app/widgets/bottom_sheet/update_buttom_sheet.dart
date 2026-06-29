import 'package:flutter/material.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import '../../core/app_export.dart';

void updateBottomSheet(){
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
        ),
        width: double.maxFinite,
        height: 372.v,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                // color: Colors.white,
                  color: appTheme.indigo800,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
              ),
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                  horizontal: 20.h, vertical: 17.v),
              // decoration: AppDecoration.heading,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Update",
                      style: CustomTextStyles
                          .titleMediumOnPrimaryContainer18),
                  AppbarImage1(
                    onTap:(){
                      Get.back();
                    },
                    svgPath: ImageConstant.imgEpcircleclose,
                  ),
                ],
              )),
          SizedBox(height: 33.v),
          CustomImageView(
              svgPath: ImageConstant.imgTrash,
              height: 69.adaptSize,
              width: 69.adaptSize),
          SizedBox(height: 25.v),
          Text('New version of app is available.',
              style: theme.textTheme.titleLarge),
          SizedBox(height: 9.v),
          Text("Please Update",
              style: theme.textTheme.bodyLarge),
          SizedBox(height: 25.v),
          CustomOutlinedButton(
              width: 220.h,
              text: "Update".toUpperCase(),
              buttonStyle: CustomButtonStyles.outlinePrimary,
              onTap: (){
                // StoreRedirect.redirect(androidAppId: "com.brighterindia.iyc",
                //     iOSAppId: "1621656001");
              }),
          SizedBox(height: 5.v)
        ])),
    barrierColor: Colors.cyan.withOpacity(0.1),
    isDismissible: false
  );
}