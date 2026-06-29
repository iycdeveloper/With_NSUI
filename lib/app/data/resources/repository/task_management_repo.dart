import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskManagementRepo {
  DioClient dioClient = sl();

  getTaskList() async {
    var data =
        '''[{"V":"${AppConstants.taskManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0000}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0000}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getTaskList,
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

  Future<List> getTaskListFromLocallySaved() async {
    final rawJson = await sl<SharedPreferences>().getString("task_list") ?? "";
    var mapList =
        rawJson.isNotEmpty ? (json.decode(rawJson) as List<dynamic>) : [];
    return mapList;
  }

  completeTask(String id, String taskInfo, String taskDateSelected) async {
    var data =
        '''[{"V":"${AppConstants.taskManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "TASK_ID":"$id","TASK_DATE":"$taskDateSelected","TASK_INFO":"$taskInfo"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.completeTask,
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

  getUserPoints() async {
    var data =
        '''[{"V":"${AppConstants.taskManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getUserPoints,
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

  getAuthPoints() async {
    var data =
    // '''[{"V":"1.5","ORG":"IYC","SESSION_ID":"Fthi4QMFNvXffpw6g6WT5b5IK6ILcx3WLsWWsLOmIC9zXjscBO4xBDs9Up0IIwAi","DEVICE_ID":"cdbbed0a-1989-4fa7-859f-fc47dab6992a","USER_ID":"G4dAjSvMvDW+Uk33JUzl6A==","LATITUDE":"3.989234383434343","LONGITUDE":"9.034342423423"}]''';

    '''[{"V":"1.5","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getAuthPoints,
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

  Future<ApiResponse> createTask(
      String type,
      String desc,
      String point,
      String startDate,
      String endDate,
      String state,
      String priority,
      String d2d,
      String bj,
      String url,
      String category,
      bool inviteClubMember) async {
    var data = '''[{"V":"${AppConstants.taskManagementVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "TASK_TYPE":"$type",
        "TASK_TEXT":"$desc",
        "TASK_POINT":"$point",
        "TASK_START_DATE":"$startDate",
        "TASK_PRIORITY":"$priority",
        "TASK_END_DATE":"$endDate",
        "TASK_USER_STATE":"$state",
        "TASK_CATEGORY":"$category",
        "D2D_COUNT":"$d2d",
        "BJ_COUNT":"$bj",
        "TASK_URL":"$url",
        "CLUB":"${inviteClubMember?1:0}"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.createTask,
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

  getTaskRating(String month, String year) async {
    var data = '''[{
        "V":"${AppConstants.taskManagementVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "MONTH":"$month",
        "YEAR":"$year"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.taskRating,
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

  Future<ApiResponse> getTaskDetails(String taskId) async {
    var data = '''[{
        "V":"${AppConstants.taskManagementVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "TASK_ID":"$taskId"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.taskDetails,
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

  getTaskStar(String month, String year) async {
    var data =
        '''[{"V":"${AppConstants.taskManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "MONTH":"$month","YEAR":"$year"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.taskStar,
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

  getDailyTaskStatus() async {
    DateTime dateTime = DateTime.now();

    String date = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
    var data =
        '''[{"V":"${AppConstants.taskManagementVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "DATE":"$date"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.taskProgress,
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
