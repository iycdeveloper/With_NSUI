import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/size_utils.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/nusi/widgets/custom_elevated_button_nsui.dart';

Future<dynamic> logoutConfirmationNSUIBottomSheet(BuildContext context) {
  mediaQueryData = MediaQuery.of(context);
  return Get.bottomSheet(
    Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        width: double.maxFinite,
        height: mediaQueryData.size.height * 0.38,
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
                  Text("Alert",
                      style: CustomTextStyles.titleMediumOnPrimaryContainer18),
                  AppbarImage1(
                    onTap: () {
                      Get.back();
                    },
                    svgPath: ImageConstant.imgEpcircleclose,
                  ),
                ],
              )),
          SizedBox(height: 25.v),
          SizedBox(
              width: mediaQueryData.size.width * 0.8,
              child: Text(
                  textAlign: TextAlign.center,
                  "Un-Synced batches exits. Logout will clear all date. Click Okay to force logout.",
                  style: theme.textTheme.titleLarge)),

          Spacer(),
          // SizedBox(height: 25.v),

          SizedBox(
            width: mediaQueryData.size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomElevatedButtonNSUI(
                    width: mediaQueryData.size.width * 0.4,
                    buttonStyle: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue)),
                    text: 'Cancel',
                    onTap: () {
                      Navigator.pop(context, false);
                    }),
                CustomElevatedButtonNSUI(
                    width: mediaQueryData.size.width * 0.4,
                    buttonStyle: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.blue)),
                    text: 'Okay',
                    onTap: () {
                      Navigator.pop(context, true);
                    }),
              ],
            ),
          ),
          SizedBox(height: 35.v),
        ])),
  );
}
