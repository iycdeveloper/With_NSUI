import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

import '../urls.dart';

class ActivityRepo {
  final DioClient dioClient;

  ActivityRepo({required this.dioClient});

  Future<ApiResponse> userActivity(
      {required String postId, required String postType}) async {
    var testJsonData = '''[{
      "V":"${AppConstants.iycVersion}",
    "ORG":"${AppConstants.orgName}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
   "DEVICE_ID":"${await getDeviceIdentifier()}",
    "CHANNEL":"${postType}",
    "POST_ID":"${postId}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));

      print("req--");
      Response result = await dioClient.post(Urls.userActivity,
          options: Options(
            contentType: Headers.textPlainContentType,
            responseType: ResponseType.plain,
            receiveDataWhenStatusError: true,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer 72c831476bfc479d:4efb65f092ac72c83147",
            },
          ),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
