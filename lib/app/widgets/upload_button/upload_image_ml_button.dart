import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import '../../core/app_export.dart';
import 'package:iyc/app/widgets/app_bar/appbar_image_1.dart';

enum DocumentType {
  amImage,
  idFront,
  idBack,
  category,
  bpl,
  caseFile,
  amVideo,
  dob,
  barCouncilId
}

class UploadButtonMlImage extends StatelessWidget {
  final Function onTap;
  final String buttonTextLabel;
  final String titleText;
  final File? pickedFile;
  final BuildContext? passedContext;
  final bool showImage;
  final onlyCamera;
  final double height;

  const UploadButtonMlImage(
      {required this.onTap,
      this.pickedFile,
      this.buttonTextLabel = "Upload Media",
      this.titleText = 'Photo',
      Key? key,
      this.showImage = false,
      this.onlyCamera = false,
      this.height = 72,
      this.passedContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectCameraGalleryBottomSheet(onTap),
      child: Container(
          margin: EdgeInsets.only(
            left: 20.h,
            top: 20.v,
            right: 20.h,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 13.v),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: appTheme.blue10001,
              width: 1.h,
            ),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('$titleText', style: theme.textTheme.bodyMedium),
              SizedBox(height: 5.v),
              Text(buttonTextLabel, style: CustomTextStyles.bodyLargeIndigo100)
            ]),
                if (showImage)
            CustomOutlinedButton(
                onTap: () {
                  if (passedContext != null)
                    FocusScope.of(passedContext!).unfocus();
                  mediaQueryData = MediaQuery.of(Get.context!);
                  if (showImage)
                    Get.bottomSheet(
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24))),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.h, vertical: 17.v),
                                child: Text("Profile Photo",
                                    style: CustomTextStyles
                                        .titleMediumOnPrimaryContainer18)),
                            Container(
                              height: 350,
                              width: double.maxFinite,
                              child: Image.file(
                                pickedFile!,
                                fit: BoxFit.contain,
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
                },
                height: 28.v,
                width: 69.h,
                text: showImage ? 'View' : 'Upload',
                margin: EdgeInsets.only(top: 16.v),
                buttonStyle: CustomButtonStyles.outlineBlueTL8,
                buttonTextStyle: CustomTextStyles.bodySmallIndigo800)
          ])),
    );
  }
}

void selectCameraGalleryBottomSheet(Function onTap) {
  mediaQueryData = MediaQuery.of(Get.context!);
  Get.bottomSheet(
    Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        width: double.maxFinite,
        height: 280.v,
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
                  Text("Upload Profile Photo",
                      style: CustomTextStyles.titleMediumOnPrimaryContainer18),
                  AppbarImage1(
                    onTap: Get.back,
                    svgPath: ImageConstant.imgEpcircleclose,
                  ),
                ],
              )),
          SizedBox(height: 10.v),
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
