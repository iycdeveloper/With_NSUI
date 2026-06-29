import 'dart:io';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageServices {
  final controller = CropController(
    aspectRatio: 0.7,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  Future<File?> pickImage(ImageSource imageSource,
      {bool cropimage = true}) async {
    final ImagePicker _picker = ImagePicker();

    final XFile? image = await _picker.pickImage(
      source: imageSource,
      imageQuality: 30,
      preferredCameraDevice: CameraDevice.front,
    );

    // try{
    //   await Navigator.push(
    //     Get.context!,
    //     MaterialPageRoute(
    //         builder: (context) => CropPhoto(photo: File(image!.path), callback: (croppedPhoto){
    //           finalPhoto = croppedPhoto;
    //         },)
    //     ),
    //   );
    //   return finalPhoto;
    // }catch(e){
    //   Log.printELog('Error i cropping photo $e');
    // }

    if (image != null && cropimage) {
      CroppedFile? croppedImage =
          await ImageCropper().cropImage(sourcePath: image.path);

      File finalImage = File(croppedImage!.path);
      return finalImage;
    }
    return File(image!.path);
  }

  Future<File?> pickVideo(ImageSource imageSource) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickVideo(source: imageSource);
    final path = await getApplicationDocumentsDirectory();
    if (image != null) {
      final filePath = "$path}";
      XFile file = XFile(filePath, name: "Video_${DateTime.now()}");
      file = image;
      File file1 = File(image.path);
      // File? croppedImage = await ImageCropper.cropImage(sourcePath: file1.path);
      return file1;
    }
    return null;
  }
}
