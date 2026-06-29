import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_export.dart';



void showUpdateAppBottomSheet(String appUrl){
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
        ),
        width: double.maxFinite,
        height: 350.v,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
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
                  Text("Update App",
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
              imagePath: 'assets/images/img_update.png',
              height: 69.adaptSize,
              width: 69.adaptSize),
          SizedBox(height: 25.v),
          Text('Update latest version',
              style: theme.textTheme.titleLarge),
          SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomElevatedButton(
                text: 'Update',
                onTap: () {
                  _launchURL(appUrl);
                }),
          ),
          SizedBox(height: 25.v),
        ])),
  );
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // Redirect to App Store for iOS
      final appStoreURL = url; // Replace with the App Store URL if necessary
      await launch(appStoreURL);
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Redirect to Google Play Store for Android
      final playStoreURL = url; // Replace with the Play Store URL if necessary
      await launch(playStoreURL);
    } else {
      // Handle unsupported platform
      Log.printELog('Unsupported platform');
    }
  } else {
    Log.printELog('Could not launch URL');
  }
}