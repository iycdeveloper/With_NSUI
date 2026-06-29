import 'dart:io';

import 'package:dio/dio.dart';
import 'package:iyc/model/api_model/response_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadServices {
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<ResponseState> download(String url) async {
    Directory directory;
    bool permissionGranted = await _requestPermission(Permission.storage);
    if (permissionGranted) {
      directory = (await getExternalStorageDirectory())!;
      print(directory);

      String path = "/storage/emulated/0/Download/";

      /// dunny url
      // String url =
      //     "https://api.ycea.in//ycea//ycea-api//service//iyc//api//v1.0//uwc//reports//SURVEY-1080-2021-07-31--12:12:42pm-1627713762.csv";
      File file = File(directory.path + "/${url.split("/").last.trim()}");

      try {
        print(url);
        //   await launchUrl(Uri.parse(url));
        final result = await Dio().download(url, file.path,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
          }
        });
        print(result);
        return ResponseState.success(file.path);
      } on DioError catch (e) {
        print("on error");
        print(e.message);
        return ResponseState.error(ErrorModel(message: "${e.message}"));
      } catch (e) {
        print("on error");
        print(e);
        return ResponseState.error(ErrorModel(message: "${e}"));
      }
    } else
      return ResponseState.error(
          ErrorModel(message: "Download failed permission denied"));
  }

  Future<ResponseState> downloadTemporary(String url) async {
    Directory directory;
    bool permissionGranted = await _requestPermission(Permission.storage);
    if (permissionGranted) {
      directory = (await getTemporaryDirectory());
      print(directory);

      String path = directory.path;
      String fileName = url.split("/").last.split("?").first;

      /// dunny url
      // String url =
      //     "https://api.ycea.in//ycea//ycea-api//service//iyc//api//v1.0//uwc//reports//SURVEY-1080-2021-07-31--12:12:42pm-1627713762.csv";
      File file = File(path + fileName);

      try {
        await Dio().download(url, file.path);
        return ResponseState.success(file.path);
      } on DioError catch (e) {
        print(e.message);
        return ResponseState.error(ErrorModel(message: "${e.message}"));
      }
    } else
      return ResponseState.error(
          ErrorModel(message: "Download failed permission denied"));
  }
}
