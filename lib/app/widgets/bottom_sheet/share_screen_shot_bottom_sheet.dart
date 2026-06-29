import 'package:flutter/material.dart';
import 'package:iyc/app/routes/routes_management.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_elevated_button.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import '../../core/app_export.dart';


void shareScreenShotBottomSheet(){
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
        ),
        width: double.maxFinite,
        height: 415.v,
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
                  Text('Share Screenshot',
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 256.h,
                        margin: EdgeInsets.only(top: 12.v, right: 38.h),
                        child: Row(
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgImage,
                              height: 20.v,
                              width: 20.h,
                            ),
                            SizedBox(width: 8.h,),
                            Text("Upload Screenshot",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: appTheme.blueGray70001,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.fSize
                                ),),
                          ],
                        )),
                    Container(
                        width: 256.h,
                        margin: EdgeInsets.only(top: 12.v, right: 38.h),
                        child: Text("msg_upload_the_screenshot".tr,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyles.bodyMediumBluegray70001_2
                                .copyWith(height: 1.60))),
                    SizedBox(height: 21.v),
                    Container(
                      // height: 80,
                      //   width: 80,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 15.v),
                        decoration:BoxDecoration(
                          borderRadius: BorderRadiusStyle.roundedBorder8,
                          border: Border.all(
                            color: appTheme.blue10001,
                            width: 1.h,
                          ),
                        ),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(

                                child: CustomImageView(
                                    svgPath: ImageConstant.imgAdd,
                                    height: 14.adaptSize,
                                    width: 14.adaptSize),
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                  color: Color(0xff1356BF),
                                  shape: BoxShape.circle
                                ),
                              ),
                              SizedBox(height: 7.v),
                              Text("lbl_upload".tr,
                                  style: CustomTextStyles
                                      .bodySmallProximaNovaGray800),
                              SizedBox(height: 2.v)
                            ])),
                    SizedBox(height: 24.v),
                    CustomElevatedButton(
                        text: "lbl_submit_now".tr.toUpperCase(),
                        onTap: () {
                        })
                  ]))
        ])),
  );
}