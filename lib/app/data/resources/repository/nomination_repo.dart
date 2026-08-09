import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

import '../urls.dart';

class NominationRepo {
  DioClient dioClient;
  NominationRepo({required this.dioClient});

  getNominationStatus() async {
    var data = '''[{
    "V":"${AppConstants.nominationVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));

      print("------------------------$data");
      Response result = await dioClient.post(Urls.getNominationStatus,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  /// Same payload as [getNominationStatus], but hits the Phase 2 endpoint.
  getNominationStatusPhase2() async {
    var data = '''[{
    "V":"${AppConstants.nominationVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? ''}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? ''}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      print("------------------------$data");
      Response result = await dioClient.post(Urls.getNominationStatusPhase2,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  updateCsn(Map<String, String> dataMap) async {
    var baseDataMap = {
      "V": "${AppConstants.nominationVersion}",
      "ORG": "${AppConstants.orgName}",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}"
    };
    baseDataMap.addAll(dataMap);
    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${json.encode(baseDataMap)}]'''));
      Response result = await dioClient.post(Urls.updateCsn,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
