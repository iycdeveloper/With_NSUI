import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

import '../urls.dart';

class ConstantApiRepo {
  final DioClient dioClient;
  ConstantApiRepo({required this.dioClient});

  getStateBallotApi() async {
    var data = '''[{"V":"${AppConstants.membershipVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getStateLisNSUI,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getDistrictBallotApi(
    String? state,
  ) async {
    var data = '''[{"V":"${AppConstants.membershipVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "STATE_CODE":"${state ?? ''}"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getDistrictLisNSUI,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getUniversityBallotApi(
    String? state,
    String? district,
  ) async {
    var data = '''[{"V":"${AppConstants.membershipVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "STATE_CODE":"${state ?? ''}",
        "DISTRICT_CODE":"${district ?? ''}"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getUniversityLisNSUI,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getCollegeBallotApi(
    String? state,
    String? district,
    String? university,
  ) async {
    var data = '''[{"V":"${AppConstants.membershipVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "STATE_CODE":"${state ?? ''}",
        "DISTRICT_CODE":"${district ?? ''}",
        "UNIVERSITY_CODE":"${university ?? ''}"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getCollegeLisNSUI,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Authorization": "Bearer ${AppConstants.authorisationKey}",
              }),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
