import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/batch_member.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';


import '../urls.dart';

class ScrutinyRepo {
  final DioClient dioClient;

  ScrutinyRepo({required this.dioClient});

  Future<ApiResponse> checkScrutinyStatus() async {
    Map<String, String> jsonData = {
      "V": "${AppConstants.scrutinyVersion}",
      "ORG": "IYC",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "LATITUDE": "${sl<LocationProvider>().currentLocation?.latitude}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation?.longitude}"
    };
    var testJsonData = '''[${json.encode(jsonData)}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result = await dioClient.post(Urls.checkScrutinyStatus,
          options: Options(
            contentType: Headers.textPlainContentType,
            responseType: ResponseType.plain,
            receiveDataWhenStatusError: true,
          ),
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> downloadBatch() async {
    var testJsonData = '''[{
    "AGGR_ID":"${await LocalStorageServices().getScrutinyAgrID()}",
    "V": "${AppConstants.scrutinyVersion}",
    "CHANNEL":"M",
    "DEVICE_ID":"${await getDeviceIdentifier()}","STATE_CODE":"${await LocalStorageServices().getSTCode()}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result =
          await dioClient.post(Urls.downloadBatch, data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> downloadAM(String batchNumber) async {
    ///TODO: make statte code dynamic

    var testJsonData = '''[{
    "AGGR_ID":"${await LocalStorageServices().getScrutinyAgrID()}",
  "V": "${AppConstants.scrutinyVersion}",
    "BATCH_NO":"$batchNumber",
    "STATE":"${await LocalStorageServices().getSTCode()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result =
          await dioClient.post(Urls.downloadAM, data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> syncBatch(
      {required List<BatchMember> membersList}) async {
    final memrberslistJSon = json.encode(membersList);

    var testJsonData = '''[{
    "MEMBER_DATA": ${memrberslistJSon},
    "AGGR_ID":"${await LocalStorageServices().getScrutinyAgrID()}",
  "V": "${AppConstants.scrutinyVersion}",
    "BATCH_NO":"${membersList.first.batchId}",
    "STATE_CODE":"${await LocalStorageServices().getSTCode()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));

      Response result =
          await dioClient.post(Urls.syncBatch, data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDobRange() async {
    var testJsonData = '''[{
    "STATE":"${await LocalStorageServices().getSTCode()}",
    "V":"${AppConstants.membershipVersion}",
    "CHANNEL":"M",
    "DEVICE_ID":"${await getDeviceIdentifier()}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result =
          await dioClient.post(Urls.DOBRange, data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
