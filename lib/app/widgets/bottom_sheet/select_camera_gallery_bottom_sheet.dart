import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import '../../core/app_export.dart';

void selectCameraGalleryBottomSheet(Function onTap, {bool disableCamera = false, bool disableGallery = false, String title = "Upload"}) {
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        width: double.maxFinite,
        height: 300.v,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$title",
                      style: CustomTextStyles.titleMediumOnPrimaryContainer18),
                  AppbarImage1(
                    onTap: Get.back,
                    svgPath: ImageConstant.imgEpcircleclose,
                  ),
                ],
              )),
          SizedBox(height: 10.v),
          if(!disableCamera)
          InkWell(
            onTap: () {
              Get.back();
              onTap(ImageSource.camera);
            },
            child: Container(
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.v),
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.h),
                color: Colors.white,
                border: Border.all(
                  color: appTheme.blue10001,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.camera,
                    color: Color(0xff2CC7E2),
                    size: 24,
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Text('Camera')
                ],
              ),
            ),
          ),
          if(!disableGallery)
          InkWell(
            onTap: () {
              Get.back();
              onTap(ImageSource.gallery);
            },
            child: Container(
              height: 60,
              margin: EdgeInsets.symmetric(
                horizontal: 20.h,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.v),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.h),
                color: Colors.white,
                border: Border.all(
                  color: appTheme.blue10001,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.photo,
                    color: Color(0xff2CC7E2),
                    size: 24,
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Text('Gallery')
                ],
              ),
            ),
          ),
          SizedBox(height: 15.v),
          CustomOutlinedButton(
              width: 220.h,
              height: 40.h,
              text: "Cancel".toUpperCase(),
              buttonStyle: CustomButtonStyles.outlinePrimary,
              onTap: Get.back),
          SizedBox(height: 5.v)
        ])),
  );
}

