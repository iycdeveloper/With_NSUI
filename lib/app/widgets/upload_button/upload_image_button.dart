import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/widgets/bottom_sheet/select_camera_gallery_bottom_sheet.dart';
import 'package:iyc/app/widgets/custom_outlined_button.dart';
import 'package:iyc/screens/widgets/video_player_local.dart';
import '../../core/app_export.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

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

class UploadButtonImage extends StatelessWidget {
  final Function onTap;
  final String buttonTextLabel;
  final String titleText;
  final File? pickedFile;
  final BuildContext? passedContext;
  final bool showImage;
  final onlyCamera;
  final disableGallery;
  final double height;
  final bool defaultPadding;
  final bool readOnly;
  final bool disableCamera;

  const UploadButtonImage(
      {required this.onTap,
      this.pickedFile,
      this.buttonTextLabel = "Upload Media",
      this.titleText = 'Photo',
      Key? key,
      this.showImage = false,
      this.onlyCamera = false,
      this.disableGallery=false,
      this.defaultPadding = false,
      this.height = 72,
      this.readOnly = false,
      this.disableCamera = false,

      this.passedContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (readOnly) return;
        selectCameraGalleryBottomSheet(onTap,
            disableCamera: disableCamera,
            disableGallery: disableGallery,
            title: buttonTextLabel);
      },
      child: Container(
          margin: defaultPadding
              ? const EdgeInsets.all(0)
              : EdgeInsets.only(
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
            CustomOutlinedButton(
                onTap: () {
                  if (passedContext != null)
                    FocusScope.of(passedContext!).unfocus();
                  mediaQueryData = MediaQuery.of(Get.context!);
                  if (showImage)
                    Get.bottomSheet(
                        Container(
                            margin: const EdgeInsets.only(top: 300),
                            decoration: const BoxDecoration(
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
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(24),
                                          topRight: Radius.circular(24))),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.h, vertical: 17.v),
                                  child: Text("$titleText",
                                      style: CustomTextStyles
                                          .titleMediumOnPrimaryContainer18)),
                              if (FileTypeValidator.isVideo(
                                  XFile(pickedFile!.path)))
                                VideoPlayerLocal(videoFile: pickedFile),
                              if (FileTypeValidator.isImage(
                                  XFile(pickedFile!.path)))
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
                                  buttonStyle:
                                      CustomButtonStyles.outlinePrimary,
                                  onTap: Get.back),
                              SizedBox(height: 5.v)
                            ])),
                        isScrollControlled: true,
                        enableDrag: true);
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

class FileTypeValidator {
  static bool isVideoByExtension(XFile pickedFile) {
    final extension = path.extension(pickedFile.path).toLowerCase();
    final videoExtensions = [
      '.mp4',
      '.avi',
      '.mov',
      '.mkv',
      '.wmv',
      '.flv',
      '.webm'
    ];
    return videoExtensions.contains(extension);
  }

  static bool isVideoByMimeType(XFile pickedFile) {
    final mimeType = lookupMimeType(pickedFile.path);
    return mimeType?.startsWith('video/') ?? false;
  }

  static bool isVideo(XFile pickedFile) {
    return isVideoByExtension(pickedFile) || isVideoByMimeType(pickedFile);
  }

  static bool isImage(XFile pickedFile) {
    final mimeType = lookupMimeType(pickedFile.path);
    return mimeType?.startsWith('image/') ?? false;
  }

  static FileType getFileType(XFile pickedFile) {
    final mimeType = lookupMimeType(pickedFile.path);
    final extension = path.extension(pickedFile.path).toLowerCase();

    if (mimeType?.startsWith('image/') ?? false) {
      return FileType.image;
    } else if (mimeType?.startsWith('video/') ?? false) {
      return FileType.video;
    } else if (['.mp4', '.avi', '.mov', '.mkv', '.wmv', '.flv', '.webm']
        .contains(extension)) {
      return FileType.video;
    } else if (['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp']
        .contains(extension)) {
      return FileType.image;
    }

    return FileType.other;
  }
}

enum FileType { image, video, other }
