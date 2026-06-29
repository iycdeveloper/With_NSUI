import 'package:flutter/material.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';

import '../../../core/app_export.dart';


void campaignSuccessBottomSheet({String? message}){
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
        ),
        width: double.maxFinite,
        height: 300.v,
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
                  Text("Submit",
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
              svgPath: ImageConstant.imgCheck,
              height: 69.adaptSize,
              width: 69.adaptSize),
          SizedBox(height: 25.v),
          Text(message??'Campaign data added successfully',
              style: theme.textTheme.titleLarge),
          SizedBox(height: 25.v),
        ])),
  );
}