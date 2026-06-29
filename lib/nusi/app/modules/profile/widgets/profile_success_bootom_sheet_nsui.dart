import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/nusi/widgets/custom_elevated_button_nsui.dart';

void profileNSUISuccessBottomSheet({String? message}) {
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        width: double.maxFinite,
        height: mediaQueryData.size.height * 0.45,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  // color: Colors.white,
                  color: appTheme.indigo800,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
              // decoration: AppDecoration.heading,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Profile Update",
                      style: CustomTextStyles.titleMediumOnPrimaryContainer18),
                  AppbarImage1(
                    onTap: () {
                      Get.back();
                    },
                    svgPath: ImageConstant.imgEpcircleclose,
                  ),
                ],
              )),
          SizedBox(height: 33.v),
          CustomImageView(
              svgPath: 'assets/nsui/svg/backtoprofile.svg',
              height: 69.adaptSize,
              width: 69.adaptSize),
          SizedBox(height: 15.v),
          Text("Update successfully", style: theme.textTheme.titleLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your profile was updated successfully.",
              textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: Colors.blueAccent)),
            ],
          ),
          // Spacer(),
          SizedBox(height: 25.v),

          CustomElevatedButtonNSUI(
              width: mediaQueryData.size.width * 0.7,
              buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue)),
              text: 'Back to Profile',
              onTap: () {
                Get.offAllNamed<void>(AppRoutes.profileScreenNSUI);
              }),
          SizedBox(height: 25.v),
        ])),
  );
}
