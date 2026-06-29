import 'package:flutter/material.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import 'package:iyc/main.dart';
import '../../core/app_export.dart';

void leaderPointBottomSheet() {
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        width: double.maxFinite,
        height: double.maxFinite,
        child: Column(children: [
          Container(
              decoration: BoxDecoration(
                  // color: Colors.white,
                  color: appTheme.indigo800,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24))),
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 17.v),
              // decoration: AppDecoration.heading,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("lbl_rewards_info".tr,
                      style: CustomTextStyles.titleMediumOnPrimaryContainer18),
                  AppbarImage1(
                    onTap: Get.back,
                    svgPath: ImageConstant.imgEpcircleclose,
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(top: 32.v, right: 20.h, left: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                  svgPath: ImageConstant.imgTrophy11,
                  height: 48.adaptSize,
                  width: 48.adaptSize,
                  margin: EdgeInsets.only(bottom: 1.v),
                ),
                Expanded(
                  child: Container(
                    width: 258.h,
                    margin: EdgeInsets.only(left: 20.h),
                    child: Text(
                      "msg_earn_reward_benefits".tr,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.titleMediumBluegray70001.copyWith(
                        height: 1.50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20.h,
              vertical: 20.v,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 12.v,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimaryContainer.withOpacity(1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    border: Border(
                      top: BorderSide(
                        color: appTheme.blue10001,
                        width: 1.h,
                      ),
                      left: BorderSide(
                        color: appTheme.blue10001,
                        width: 1.h,
                      ),
                      bottom: BorderSide(
                        color: appTheme.blue10001,
                        width: 1.h,
                      ),
                      right: BorderSide(
                        color: appTheme.blue10001,
                        width: 1.h,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.v),
                        child: Text(
                          "lbl_booth_jodo".tr,
                          style: CustomTextStyles.bodyMediumIndigo800,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 3.v,
                          right: 10.h,
                        ),
                        child: Text(
                          "lbl_1_point".tr,
                          style: CustomTextStyles.bodyLargeIndigo800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 12.v,
                  ),
                  decoration: AppDecoration.outlineBlue100015,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.v),
                        child: Text(
                          "lbl_d2d".tr,
                          style: CustomTextStyles.bodyMediumIndigo800,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 3.v,
                          right: 10.h,
                        ),
                        child: Text(
                          "lbl_1_point".tr,
                          style: CustomTextStyles.bodyLargeIndigo800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 12.v,
                  ),
                  decoration: AppDecoration.outlineBlue100015,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.v),
                        child: Text(
                          "lbl_social_media".tr,
                          style: CustomTextStyles.bodyMediumIndigo800,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 3.v,
                          right: 10.h,
                        ),
                        child: Text(
                          "lbl_1_point".tr,
                          style: CustomTextStyles.bodyLargeIndigo800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 12.v,
                  ),
                  decoration: AppDecoration.outlineBlue100015,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 4.v,
                          bottom: 2.v,
                        ),
                        child: Text(
                          "lbl_reporting".tr,
                          style: CustomTextStyles.bodyMediumIndigo800,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 4.v,
                          right: 10.h,
                        ),
                        child: Text(
                          "lbl_1_point".tr,
                          style: CustomTextStyles.bodyLargeIndigo800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 12.v,
                  ),
                  decoration: AppDecoration.outlineBlue100015,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.v),
                        child: Text(
                          "msg_self_initiated_work".tr,
                          style: CustomTextStyles.bodyMediumIndigo800,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 3.v,
                          right: 10.h,
                        ),
                        child: Text(
                          "lbl_1_point".tr,
                          style: CustomTextStyles.bodyLargeIndigo800,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 12.v,
                  ),
                  decoration: AppDecoration.outlineBlue100015,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 3.v),
                        child: Text(
                          "lbl_other_campaigns".tr,
                          style: CustomTextStyles.bodyMediumIndigo800,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 3.v,
                          right: 10.h,
                        ),
                        child: Text(
                          "lbl_1_point".tr,
                          style: CustomTextStyles.bodyLargeIndigo800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 30.v),
        ])),
  );
}
