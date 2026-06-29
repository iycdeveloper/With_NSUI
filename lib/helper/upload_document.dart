import 'dart:io';

import 'package:iyc/app/data/resources/services/aws_upload_services.dart';


Future<bool> uploadDocument(
    String? filePath, String destinationDirectory, String fileName) async {
  if (filePath == null) {
    return false;
  }
  String? result = await AwsUploadServices().uploadFile(
      file: File(filePath), destDir: destinationDirectory, filename: fileName);

  if (result is String)
    return true;
  else
    return false;
}
