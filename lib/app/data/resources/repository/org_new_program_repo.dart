import 'dart:convert';

import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/utils/utils.dart';

class OrgNewProgramRepo {
  DioClient dioClient = sl();

  getViewProgramList() async {
    var data =
        '''[{"V":"${AppConstants.formVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0000}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0000}",
        "HOME_STATE_CODE":"${await LocalStorageServices().getSTCode()}"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.orgViewProgram,
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

  checkOBAccess() async {
    var data =
        '''[{"V":"${AppConstants.formVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0}",
        "HOME_STATE_CODE":"${await LocalStorageServices().getSTCode()}"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.orgNewProCheckOBAccess,
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

  addProgRedFlag(Map<String, String> addProgramFlag) async {
    var baseData = {
      "V": AppConstants.formVersion,
      "ORG": "${AppConstants.orgName}",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "LATITUDE":
          "${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}",
      "LONGITUDE":
          "${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}"
    };

    baseData.addAll(addProgramFlag);

    try {
      var data = '''[${jsonEncode(baseData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.orgAddProgramRedFlag,
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

  getViewProgramFlagData(String? programID) async {
    var data =
        '''[{"V":"${AppConstants.formVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0000}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0000}",
        "HOME_STATE_CODE":"${await LocalStorageServices().getSTCode()}",
        "PROGRAM_ID":"$programID"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.orgViewProgramFlag,
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


  addNOBProgramReview(Map<String, String> addProgramFlag) async {
    var baseData = {
      "V": AppConstants.formVersion,
      "ORG": "${AppConstants.orgName}",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "LATITUDE":
          "${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}",
      "LONGITUDE":
          "${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}"
    };

    baseData.addAll(addProgramFlag);

    try {
      var data = '''[${jsonEncode(baseData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.orgProgVerificationByNOB,
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
