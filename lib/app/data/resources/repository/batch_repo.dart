import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

import '../urls.dart';

class BatchRepo {
  final DioClient dioClient;

  BatchRepo({required this.dioClient});

  Future agrCreateBatch() async {
    final position = await sl<LocationProvider>().determinePosition();

    if (position is Position) {
      // continue  after else
    } else {
      print("here error");

      return ApiResponse.withError(
          "Location Fetch failed, Location is mandatory for creating new membership"); // close execution
    }
    var data =
        '''[{"AGGR_ID":"${await LocalStorageServices().getAgrIDMembership()}",
    "ST_CODE":"${await LocalStorageServices().getSTCode()}",
    "DIS_CODE":"${await LocalStorageServices().getDisCode()}",
    "V":"${AppConstants.membershipVersion}",
    "CHANNEL":"${AppConstants.channel}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
     "LATITUDE":"${position.latitude}","LONGITUDE":"${position.longitude}"


    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.agrCreateBatch,
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

  Future downloadExistingBatch() async {
//"AGGR_ID":"${await LocalStorageServices().getAgrID()}",
    var data = '''[{
    "AGGR_ID":"${await LocalStorageServices().getAgrIDMembership()}",
    "ST_CODE":"${await LocalStorageServices().getSTCode()}",
    "V":"${AppConstants.membershipVersion}",
    "CHANNEL":"${AppConstants.channel}",
    "DEVICE_ID":"${await getDeviceIdentifier()}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.agrDownloadBatches,
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

  getAggrId() async {
    final position = await sl<LocationProvider>().determinePosition();

    if (position is Position) {
      // continue  after else
    } else {
      print("here error");

      return ApiResponse.withError(
          "Location Fetch failed, Location is mandatory for creating membership"); // close execution
    }
    var data = '''[{
    "V":"${AppConstants.membershipVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "LATITUDE":"${position.latitude}","LONGITUDE":"${position.longitude}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getAggrId,
          options: Options(
              contentType: Headers.textPlainContentType,
              responseType: ResponseType.plain,
              receiveDataWhenStatusError: true,
              headers: {
                "Accept": "application/json",
                "Authorization": "Bearer 72c831476bfc479d:4efb65f092ac72c83147",
              }),
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future logout() async {}

  getDobRange() async {
    var data = '''[{
    "V":"${AppConstants.membershipVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getAggrId,
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

  getCSNOTP(String memberID) async {
    var data = '''[{
    "V":"${AppConstants.membershipVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}","MEMBER_ID":"$memberID"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getCSNOTP,
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

  validateCSNOTP(String otp, String memberID) async {
    var data = '''[{
    "V":"${AppConstants.membershipVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}","MEMBER_ID":"${memberID}","OTP":"${otp}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.validateCSNOTP,
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
