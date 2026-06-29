import 'package:flutter/material.dart';
import 'package:iyc/app/modules/profile/profile_controller.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';
import 'package:iyc/app/widgets/upload_button/upload_image_button.dart';
import 'package:iyc/nusi/app/modules/profile/screens/profile_controller_nsui.dart';

import '../../../core/app_export.dart';


void profilePhotoChangeViewBottomSheet(){
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
        ),
        width: double.maxFinite,
        height: 203.v,
        child: Column(
            children: [
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
                  Text("Change Profile Photo",
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
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Container(
          //     width: double.maxFinite,
          //     decoration: BoxDecoration(
          //         border: Border.all(
          //           color: appTheme.blue10001,
          //           width: 1.h,
          //         )
          //     ),
          //     child: Center(
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(vertical: 10.v),
          //         child: Text('View Photo',
          //           style: CustomTextStyles.bodyMediumIndigo800,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // InkWell(
          //   // onTap: ()=> selectCameraGalleryBottomSheet(onTap),
          //   child: Padding(
          //     padding: const EdgeInsets.fromLTRB(16,0,16,0),
          //     child: Container(
          //       width: double.maxFinite,
          //       decoration: BoxDecoration(
          //         border: Border.all(
          //               color: appTheme.blue10001,
          //               width: 1.h,
          //         )
          //       ),
          //       child: Center(
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(vertical: 10.v),
          //           child: Text('Change Photo',
          //             style: CustomTextStyles.bodyMediumIndigo800,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
              GetBuilder<ProfileNSUIController>(
                builder: (logic) {
                  return UploadButtonImage(
                    onTap: (str) {
                      Get.back();
                      logic.pickDocument(str, logic.pickedAMFilePath,
                          DocumentType.amImage, Get.context!);
                    },
                    showImage: logic.pickedAMFilePath != null,
                    pickedFile: logic.pickedAMFile,
                    buttonTextLabel: "Upload Profile Photo",
                  );
                }
              ),
        ])),
  );
}