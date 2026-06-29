import 'package:flutter/material.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_icon_button.dart';
import '../../core/app_export.dart';


void sharePostLinkBottomSheet(){
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
                  Text('Share Post Link',
                      style: CustomTextStyles
                          .titleMediumOnPrimaryContainer18),
                  AppbarImage1(
                    onTap: Get.back,
                    svgPath: ImageConstant.imgEpcircleclose,
                  ),
                ],
              )),
          SizedBox(height: 20.v),
          Container(
              width: 335.h,
              margin: EdgeInsets.fromLTRB(20.h, 0, 20.h, 20.v),
              padding: EdgeInsets.all(20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusStyle.roundedBorder16,
                border: Border.all(
                  color: appTheme.blue10001,
                  width: 1.h,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomIconButton(
                            height: 60.adaptSize,
                            width: 60.adaptSize,
                            margin: EdgeInsets.only(right: 12.h),
                            padding: EdgeInsets.all(12.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgWhatsapp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomIconButton(
                            height: 60.adaptSize,
                            width: 60.adaptSize,
                            margin: EdgeInsets.symmetric(horizontal: 12.h),
                            padding: EdgeInsets.all(12.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgInstagram,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomIconButton(
                            height: 60.adaptSize,
                            width: 60.adaptSize,
                            margin: EdgeInsets.symmetric(horizontal: 12.h),
                            padding: EdgeInsets.all(12.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgFacebook,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomIconButton(
                            height: 60.adaptSize,
                            width: 60.adaptSize,
                            margin: EdgeInsets.only(left: 12.h),
                            padding: EdgeInsets.all(12.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgGroup242003,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 24.v,
                      right: 1.h,
                      bottom: 4.v,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomIconButton(
                            height: 60.adaptSize,
                            width: 60.adaptSize,
                            margin: EdgeInsets.only(right: 12.h),
                            padding: EdgeInsets.all(12.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgTwitter,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomIconButton(
                            height: 60.adaptSize,
                            width: 60.adaptSize,
                            margin: EdgeInsets.symmetric(horizontal: 12.h),
                            padding: EdgeInsets.all(12.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgGmail,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomIconButton(
                            height: 60.adaptSize,
                            width: 60.adaptSize,
                            margin: EdgeInsets.symmetric(horizontal: 12.h),
                            padding: EdgeInsets.all(12.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgMessenger,
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomIconButton(
                            height: 60.adaptSize,
                            width: 60.adaptSize,
                            margin: EdgeInsets.only(left: 12.h),
                            padding: EdgeInsets.all(12.h),
                            child: CustomImageView(
                              imagePath: ImageConstant.imgGoogledrive,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ])),
  );
}