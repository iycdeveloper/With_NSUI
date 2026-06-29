
import 'package:flutter/material.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';

import '../../../core/app_export.dart';

// ignore_for_file: must_be_immutable
class RewardsDetailScreen extends StatelessWidget {
  const RewardsDetailScreen({Key? key})
      : super(
    key: key,
  );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF8FAFF),
        body: SizedBox(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 5.v),
              child: Stack(
                children: [
                  SizedBox(
                    height: 328.v,
                    width: double.maxFinite,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 220.v,
                            width: double.maxFinite,
                            child: Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                CustomImageView(
                                  imagePath:
                                  ImageConstant.imgCloseupmicrop220x375,
                                  height: 220.v,
                                  width: 375.h,
                                  alignment: Alignment.center,
                                ),
                                CustomImageView(
                                  onTap: Get.back,
                                  svgPath: ImageConstant.imgBiarrowleft,
                                  height: 24.adaptSize,
                                  width: 24.adaptSize,
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                    left: 20.h,
                                    top: 12.v,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.h,
                              vertical: 17.v,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadiusStyle.roundedBorder16,
                                border: Border.all(width: 1, color: Color(0xffC0D5F3))
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 272.h,
                                  margin: EdgeInsets.only(
                                    top: 3.v,
                                    right: 22.h,
                                  ),
                                  child: Text(
                                    "msg_yippe_you_have".tr,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomTextStyles.titleLargeBlack900
                                        .copyWith(
                                      height: 1.40,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 11.v),
                                Row(
                                  children: [
                                    CustomImageView(
                                      svgPath:
                                      ImageConstant.imgTablercalendardue,
                                      height: 16.adaptSize,
                                      width: 16.adaptSize,
                                      margin:
                                      EdgeInsets.symmetric(vertical: 2.v),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 12.h),
                                      child: Text(
                                        "lbl_10_jun_2023".tr,
                                        style: theme.textTheme.bodyLarge,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: 20.h,
                      top: 370.v,
                      right: 20.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.h,
                      vertical: 23.v,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusStyle.roundedBorder16,
                      border: Border.all(width: 1, color: Color(0xffC0D5F3))
                    ),
                    // decoration: AppDecoration.outlineBlue.copyWith(
                    //   borderRadius: BorderRadiusStyle.roundedBorder16,
                    // ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 67.h),
                          child: Row(
                            children: [
                              CustomImageView(
                                svgPath: ImageConstant.imgCalendar51,
                                height: 24.adaptSize,
                                width: 24.adaptSize,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 12.h,
                                  top: 2.v,
                                ),
                                child: Text(
                                  "msg_expires_on_30_sep".tr,
                                  style: CustomTextStyles.titleMediumMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.v),
                        Row(
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgTrophy31,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12.h),
                              child: Text(
                                "lbl_prize_details".tr,
                                style: CustomTextStyles.titleMediumMedium,
                              ),
                            ),
                            Spacer(),
                            CustomImageView(
                              svgPath: ImageConstant.imgAkariconsarrowup,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                            ),
                          ],
                        ),
                        Container(
                          width: 285.h,
                          margin: EdgeInsets.only(
                            left: 7.h,
                            top: 21.v,
                            right: 2.h,
                          ),
                          child: Text(
                            "msg_lorem_ipsum_dolor".tr,
                            maxLines: 7,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.bodyMediumBluegray70001_2
                                .copyWith(
                              height: 1.60,
                            ),
                          ),
                        ),
                        SizedBox(height: 29.v),
                        Row(
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgInformation3,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 12.h,
                                top: 3.v,
                              ),
                              child: Text(
                                "lbl_about_organizer".tr,
                                style: CustomTextStyles.titleMediumMedium,
                              ),
                            ),
                            Spacer(),
                            CustomImageView(
                              svgPath: ImageConstant.imgAkariconsarrowup,
                              height: 24.adaptSize,
                              width: 24.adaptSize,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(
            left: 20.h,
            right: 20.h,
            bottom: 16.v,
          ),
          decoration: AppDecoration.outlineBlue100011,
          child: CustomElevatedButton(
            text: "CLAIM YOUR REWARD".toUpperCase(),
          ),
        ),
      ),
    );
  }
}
