import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/user_detail/uer_detail_response.dart';
import 'package:iyc/model/data_model/login_model.dart';
import 'package:iyc/model/data_model/registrer_model.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

import '../urls.dart';

class AuthRepo {
  final DioClient dioClient;

  AuthRepo({required this.dioClient});

  Future<ApiResponse> register({
    required RegisterModel data,
    required String address,
    required String pincode,
    required String tag,
    required String referralMobileNo,
  }) async {
    var testJsonData = '''[{
    "V":"${AppConstants.iycVersion}",
    "ORG":"${AppConstants.orgName}",
    "NAME":"${data.name}",
    "MOBILE":"${data.mobile}",
    "GENDER":"${data.genderCode}",
    "DOB":"${data.dob}",
    "STATE_CODE":"${data.stateCode}",
    "DISTRICT_CODE":"${data.districtCode ?? ""}",
    "ASSEMBLY_CODE":"${data.assemblyCode ?? ""}",
    "BLOCK_CODE":"${data.blockCode ?? ""}",
    "FACEBOOK":"${data.fbId ?? ""}",
    "twitter":"${data.twitterId ?? ""}",
    "INSTAGRAM":"${data.instagramId ?? ""}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "ADDRESS":"$address",
    "REFERRER":"$referralMobileNo",
    "tag":"$tag",
    "CASTE":"${data.caste}",
    "SUBCASTE":"${data.subCaste}",
    "PINCODE":"$pincode"}]''';
    Log.printILog(testJsonData);
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      final httpResult = await http.Client().post(
        Uri.parse(Urls.register),
        body: base64encoded,
        headers: {
          "Accept": "application/json",
          "Content-type": "${Headers.textPlainContentType}",
          "Authorization": "Bearer ${AppConstants.authorisationKey}",
        },
      );

      Response result = Response(
          data: httpResult.body,
          requestOptions: RequestOptions(
              path: Urls.register, data: base64encoded, method: "POST"),
          statusCode: httpResult.statusCode);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> login({required LoginModel loginModel}) async {
    var testJsonData = '''[{
    "ORG":"IYC",
        "MOBILE":"${loginModel.mobile}",
        "V":"${AppConstants.iycVersion}",
        "CHANNEL":"${AppConstants.channel}",
        "DEVICE_ID":"${await getDeviceIdentifier()}"      
      }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result = await dioClient.post(Urls.login,
          options: Options(
            contentType: Headers.textPlainContentType,
            responseType: ResponseType.plain,
            receiveDataWhenStatusError: true,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer ${AppConstants.authorisationKey}",
            },
          ),
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future verifyOtpLogin(Map<String, dynamic> loginData) async {
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    loginData.addAll({
      "V": "${AppConstants.iycVersion}",
      "CHANNEL": "${AppConstants.channel}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "DEVICE_TOKEN": 'fcmToken',
    });
    Log.printILog('fcmToken');
    var data = '''[${json.encode(loginData)}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.verifyLoginOtp,
          options: Options(
            contentType: Headers.textPlainContentType,
            responseType: ResponseType.plain,
            receiveDataWhenStatusError: true,
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer ${AppConstants.authorisationKey}",
            },
          ),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> logout() async {
    var testJsonData = '''[{
    "V":"${AppConstants.iycVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));

      Response result = await dioClient.post(Urls.logout, data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteAccount() async {
    var testJsonData = '''[{
    "V":"${AppConstants.iycVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));

      Response result =
          await dioClient.post('auth/deleteUser.php', data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> loginMembership({required LoginModel loginModel}) async {
    var testJsonData = '''[{
        "NAME":"${loginModel.name}",
        "ST_CODE":"${loginModel.stateCode}",
        "DIS_CODE":"${loginModel.districtCode}",
        "MOBILE":"${loginModel.mobile}",
        "EMAIL":"${loginModel.email}",
        "V":"${AppConstants.membershipVersion}",
        "CHANNEL":"${AppConstants.channel}",
        "DEVICE_ID":"${await getDeviceIdentifier()}"      
      }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result = await dioClient.post(Urls.aggrRegister,
          options: Options(
            contentType: Headers.textPlainContentType,
            responseType: ResponseType.plain,
            receiveDataWhenStatusError: true,
            headers: {
              "Accept": "application/json",
              "Authorization":
                  "Bearer WQ2ylaFMNFyc24M38LVzfb8J9OUz03NJss:DxMiWtWwoBvH5adCWXRZo",
            },
          ),
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserDetails() async {
    var testJsonData = '''[{
    "V":"${AppConstants.iycVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? "0.00001"}",
"LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? "0.00001"}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));

      Response result =
          await dioClient.post(Urls.getUserDetails, data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUserProfilePhoto() async {
    print('https://memberdoc.ycea.in/PROFILE/9916557335_P.jpg');
    var testJsonData = '''[{
    "V":"${AppConstants.iycVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? "0.00001"}",
"LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? "0.00001"}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));

      Response result = await dioClient.post(
          'https://memberdoc.ycea.in/PROFILE/9916557335_P.jpg',
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getLeaderBoard(String selectedLeaderBoardType,
      {String startDate = '', String endDate = ''}) async {
    var testJsonData = '''[{
    "V":"${AppConstants.iycVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? "0.00001"}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? "0.00001"}",
    "LEADERBOARD_TYPE":"$selectedLeaderBoardType",
    "FROM": "${startDate}",
    "TO":"${endDate}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result =
          await dioClient.post(Urls.getLeaderBoard, data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> editProfile(UserDetail userDetail) async {
    var testJsonData = '''[{
    "V":"${AppConstants.iycVersion}",
    "ORG":"${AppConstants.orgName}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? "0.00001"}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? "0.00001"}",
    "NAME":"${userDetail.name}",
    "DISTRICT_CODE":"${userDetail.districtCode}",
    "ASSEMBLY_CODE":"${userDetail.assemblyCode}",
    "BOOTH_CODE":"${userDetail.wardCode}",
    "ADDRESS":"${userDetail.address}",
    "PINCODE":"${userDetail.pincode}",
     "CASTE":"${userDetail.category}",
    "SUBCASTE":"${userDetail.subCategory}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result =
          await dioClient.post(Urls.editProfile, data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAuthPoints() async {
    var data =
        '''[{"V":"${AppConstants.iycVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude}"}]''';
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

  Future<ApiResponse> getUserPoints() async {
    var data =
        '''[{"V":"${AppConstants.taskManagementVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude}"}]''';
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
}
