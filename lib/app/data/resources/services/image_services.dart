import 'dart:io';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/app/core/utils/snackbar.dart';

class ImageServices {
  final controller = CropController(
    aspectRatio: 0.7,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  /// Friendly, user-facing message for anything the camera / gallery pickers
  /// can throw — denied permissions, an OEM camera app that dies, a device
  /// that runs out of memory decoding a large photo.
  static String describePickError(Object e) {
    if (e is PlatformException) {
      switch (e.code) {
        case 'camera_access_denied':
          return 'Camera permission is denied. Please allow camera access in Settings and try again.';
        case 'photo_access_denied':
        case 'gallery_access_denied':
          return 'Photo/storage permission is denied. Please allow it in Settings and try again.';
        default:
          return 'Could not open the camera/gallery: ${e.message ?? e.code}';
      }
    }
    if (e is OutOfMemoryError) {
      return 'The device ran out of memory handling this file. Please close other apps and try again with a smaller photo.';
    }
    if (e is FileSystemException) {
      return 'Could not read/save the file: ${e.osError?.message ?? e.message}. Please check storage space and permissions.';
    }
    return 'Something went wrong while picking the file. Please try again.';
  }

  /// Returns null on cancel, denied permission, or ANY failure — never throws,
  /// so a missing permission can't take the app down. Real failures are
  /// surfaced to the user as a snackbar before returning null.
  Future<File?> pickImage(ImageSource imageSource,
      {bool cropimage = true}) async {
    final ImagePicker picker = ImagePicker();

    XFile? image;
    try {
      image = await picker.pickImage(
        source: imageSource,
        imageQuality: 30,
        preferredCameraDevice: CameraDevice.front,
      );
    } catch (e) {
      Log.printELog('pickImage failed: $e');
      CustomSnackBar.showErrorSnackBar(describePickError(e));
      return null;
    }

    /// User backed out of the camera/gallery, or the platform handed back
    /// nothing. Not an error — just no file, so no message.
    if (image == null) return null;

    if (!cropimage) return File(image.path);

    try {
      final CroppedFile? croppedImage =
          await ImageCropper().cropImage(sourcePath: image.path);

      /// Cropper cancelled — keep the original photo rather than crashing on
      /// a null cropped result.
      return croppedImage == null ? File(image.path) : File(croppedImage.path);
    } catch (e) {
      Log.printELog('cropImage failed: $e');
      CustomSnackBar.showErrorSnackBar(describePickError(e));
      return File(image.path);
    }
  }

  /// Same contract as [pickImage] — null instead of an exception.
  Future<File?> pickVideo(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? video = await picker.pickVideo(source: imageSource);
      if (video == null) return null;
      return File(video.path);
    } catch (e) {
      Log.printELog('pickVideo failed: $e');
      CustomSnackBar.showErrorSnackBar(describePickError(e));
      return null;
    }
  }
}
