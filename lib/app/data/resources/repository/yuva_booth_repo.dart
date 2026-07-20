import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';


import '../remote/exception/api_error_handler.dart';
import '../services/local_storage_services.dart';
import '../urls.dart';

class YuvaBoothRepo {
  DioClient dioClient = sl();

  getYuvaUser() async {
    var data =
        '''[{"V":"${AppConstants.yuvaBoothVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.000}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.000}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getYuvaUser,
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

  getYuvaUserNew() async {
    var data =
        '''[{"V":"${AppConstants.yuvaBoothVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.000}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.000}"}]''';
    print(data);
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getYuvaUserNew,
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

  getAllYuvaUsers(String? stateCode) async {
    var data =
        '''[{"V":"${AppConstants.yuvaBoothVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "STATE_CODE":"${stateCode ?? ""}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getAllYuvaUsers,
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

  initiateOutboundCall(String mobile, String randomNumber) async {
    var testJsonData = '''[{
    "V":"${AppConstants.iycVersion}",
    "ORG":"NSUI",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
    "MOBILE":"$mobile",
    "TRANSACTION_ID":"$mobile-$randomNumber"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result =
      await dioClient.post(Urls.initiateOutboundCall, data: base64encoded);

      return ApiResponse.withSuccess(result);
    } on Exception catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  verifyOutboundCall(String mobile) async {
    var testJsonData = '''[{
    "V":"${AppConstants.iycVersion}",
    "ORG":"NSUI",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
    "MOBILE":"$mobile"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result =
      await dioClient.post(Urls.verifyOutboundCall, data: base64encoded);

      return ApiResponse.withSuccess(result);
    } on Exception catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getOtp(String mobile) async {
    var testJsonData = '''[{
    "STATE_CODE":"${await LocalStorageServices().getWorkStateCode()}",
    "MOBILE":"$mobile",
    "CHANNEL":"${AppConstants.channel}",
    "V":"${AppConstants.iycVersion}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result =
          await dioClient.post(Urls.getOtpCommon, data: base64encoded);

      return ApiResponse.withSuccess(result);
    } on Exception catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  verifyOtp(String mobile, String otp) async {
    var testJsonData = '''[{
    "STATE_CODE":"${await LocalStorageServices().getSTCode()}",
    "MOBILE":"$mobile",
    "OTP":"$otp",
    "CHANNEL":"${AppConstants.channel}",
    "V":"${AppConstants.iycVersion}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
    "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));
      Response result =
          await dioClient.post(Urls.validateOtpCommon, data: base64encoded);

      return ApiResponse.withSuccess(result);
    } on Exception catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  addYuvaUser(Map<String, String> dataMap) async {
    var baseDataMap = {
      "V": AppConstants.yuvaBoothVersion,
      "ORG": AppConstants.orgName,
      "SESSION_ID": await LocalStorageServices().getSessionId(),
      "DEVICE_ID": await getDeviceIdentifier(),
      "USER_ID": await LocalStorageServices().getUserId(),
      "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}"
    };
    baseDataMap.addAll(dataMap);
    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${json.encode(baseDataMap)}]'''));
      Response result = await dioClient.post(Urls.addYuvaUser,
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

  addAssignment(Map<String, String> dataMap) async {
    var baseDataMap = {
      "V": AppConstants.yuvaBoothVersion,
      "ORG": AppConstants.orgName,
      "SESSION_ID": await LocalStorageServices().getSessionId(),
      "DEVICE_ID": await getDeviceIdentifier(),
      "USER_ID": await LocalStorageServices().getUserId(),
      "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}"
    };
    baseDataMap.addAll(dataMap);
    try {
      var base64encoded =
      base64.encode(utf8.encode('''[${json.encode(baseDataMap)}]'''));
      Response result = await dioClient.post(Urls.addAssignment,
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

  checkMobileExist(String mobile) async {
    var baseDataMap = {
      "V": AppConstants.yuvaBoothVersion,
      "ORG": AppConstants.orgName,
      "SESSION_ID": await LocalStorageServices().getSessionId(),
      "DEVICE_ID": await getDeviceIdentifier(),
      "USER_ID": await LocalStorageServices().getUserId(),
      "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}",
      "MOBILE": mobile,
      "STATE_CODE": await LocalStorageServices().getWorkStateCode()
    };

    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${json.encode(baseDataMap)}]'''));
      Response result = await dioClient.post(Urls.checkBoothJodoExist,
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

  addYuvaUserNew(Map<String, String> dataMap) async {
    var baseDataMap = {
      "V": AppConstants.yuvaBoothVersion,
      "ORG": AppConstants.orgName,
      "SESSION_ID": await LocalStorageServices().getSessionId(),
      "DEVICE_ID": await getDeviceIdentifier(),
      "USER_ID": await LocalStorageServices().getUserId(),
      "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}"
    };
    baseDataMap.addAll(dataMap);
    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${json.encode(baseDataMap)}]'''));
      Response result = await dioClient.post(Urls.addYuvaUserNew,
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

  addYuvaDataMeeting(Map<String, String> map) async {
    var data = {
      "V": AppConstants.yuvaBoothVersion,
      "ORG": AppConstants.orgName,
      "SESSION_ID": await LocalStorageServices().getSessionId(),
      "DEVICE_ID": await getDeviceIdentifier(),
      "USER_ID": await LocalStorageServices().getUserId(),
      "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}"
    };
    try {
      data.addAll(map);
      var base64encoded =
          base64.encode(utf8.encode('''[${json.encode(data)}]'''));
      Response result = await dioClient.post(Urls.addYuvaDataMeeting,
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

  addBoothJodo(Map<String, String> map) async {
    var baseDataMap = {
      "V": AppConstants.yuvaBoothVersion,
      "ORG": AppConstants.orgName,
      "SESSION_ID": await LocalStorageServices().getSessionId(),
      "DEVICE_ID": await getDeviceIdentifier(),
      "USER_ID": await LocalStorageServices().getUserId(),
    };
    baseDataMap.addAll(map);
    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${json.encode(baseDataMap)}]'''));

      Response result = await dioClient.post(Urls.addBoothData,
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

  getBoothJodos() async {
    var data =
        '''[{"V":"${AppConstants.yuvaBoothVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getAllBoothJodos,
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

  getLeaderBoardPoints(String leaderBoardType) async {
    var data =
        '''[{"V":"${AppConstants.yuvaBoothVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
        "STATE_CODE":"${await LocalStorageServices().getSTCode()}","LEADERBOARD_TYPE":"$leaderBoardType"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.boothJodoLeaderBoard,
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

  checkInYuvaBooth(String description,String city2,String state2) async {
    String address = "";
    var city = '';
    var state = '';

    convertToAddress(double lat, double long, String apikey) async {
      Dio dio = Dio();
      String apiurl =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$apikey";
      Response response = await dio.get(apiurl); //send get request to API URL
      if (response.statusCode == 200) {
        Map data = response.data; //get response data
        Log.printDLog(data);
        if (data["status"] == "OK") {
          if (data["results"].length > 0) {
            Map firstResult = data["results"][0]; //select the first address
            address = firstResult["formatted_address"]; //get the address
            var test = firstResult["address_components"];
            (test as List).forEach((e) {
              if (e["types"].contains("locality")) city = e["short_name"];
              if (e["types"].contains("administrative_area_level_1"))
                state = e["long_name"];
            });
            return [address, city, state];
          }
        } else {
          return null;
        }
      } else {
        print("error while fetching geocoding data");
        return null;
      }
    }

    final position = await sl<LocationProvider>().determinePosition();

    if (position is Position) {
      await convertToAddress(position.latitude, position.longitude,
          "AIzaSyBQaoLL-DePeRTz-CFxg6BSKL1Q2gf4SxE");
    } else {
      print("here error");

      return ApiResponse.withError(position); // close execution
    }

    var data =
        '''[{"V":"${AppConstants.checkInVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${position.latitude}","LONGITUDE":"${position.longitude}","ADDRESS":"$address","DESCRIPTION":"$description",
        "CHECKIN_STATE":"$state2","CHECKIN_CITY":"$city2"}]''';

    Log.printELog(address);
    log(data);
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.checkInYuvaBooth,
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

  getCheckInData() async {
    var data =
        '''[{"V":"${AppConstants.checkInVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getCheckInData,
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

  getReports(String reportType) async {
    var data =
        '''[{"V":"${AppConstants.yuvaBoothVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
        "STATE_CODE":"${await LocalStorageServices().getSTCode()}","REPORT_TYPE":"$reportType"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.boothJodoReports,
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
