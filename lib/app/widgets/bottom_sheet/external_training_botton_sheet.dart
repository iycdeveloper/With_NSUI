import 'package:flutter/material.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import '../../core/app_export.dart';


void createExternalTrainingSuccessBottomSheet(){
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
                  Text("Create External Training",
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
          Text("msg_thanks_for_the_submission".tr,
              style: theme.textTheme.titleLarge),
          SizedBox(height: 9.v),
          Text("External Training Created".tr,
              style: theme.textTheme.bodyLarge),
          SizedBox(height: 25.v),
          CustomOutlinedButton(
              width: 220.h,
              text: "Back".toUpperCase(),
              buttonStyle: CustomButtonStyles.outlinePrimary,
              onTap: Get.back),
          SizedBox(height: 5.v)
        ])),
  );
}