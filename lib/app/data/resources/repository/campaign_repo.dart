import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

class CampaignRepo {
  DioClient dioClient = sl();

  getCampaignList() async {
    var data =
        '''[{"V":"${AppConstants.d2DCampaignVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0000}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0000}",
        "WORK_STATE":"${await LocalStorageServices().getWorkStateCode()}",
        "HOME_STATE":"${await LocalStorageServices().getSTCode()}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getCampaignList,
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

  getCampaignDataList(String campaignId) async {
    var data =
        '''[{"V":"${AppConstants.d2DCampaignVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0000}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0000}",
        "CAMPAIGN_ID":"$campaignId"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.viewCampaignData,
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

  checkAssembly(String campaignId) async {
    var data =
        '''[{"V":"${AppConstants.d2DCampaignVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0000}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0000}",
        "CAMPAIGN_ID":"$campaignId"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getAssemblyCampaign,
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

  getCampaignLeaderboard(String selectedCampaign) async {
    var data =
        '''[{"V":"${AppConstants.d2DCampaignVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0000}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0000}",
        "CAMPAIGN_ID":"$selectedCampaign","LEADERBOARD_TYPE":"STATE"
       }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.viewCampaignLeaderBoard,
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

  addCampaignData(Map<String, String> campaignData) async {
    var baseData = {
      "V": "${AppConstants.d2DCampaignVersion}",
      "ORG": "${AppConstants.orgName}",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "LATITUDE":
          "${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}",
      "LONGITUDE":
          "${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
    };

    baseData.addAll(campaignData);

    try {
      var data = '''[${jsonEncode(baseData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.addCampaignData,
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

  addChaloPanchayat(Map<String, String> chaloPanchayatData) async {
    try {
      var data = '''[${jsonEncode(chaloPanchayatData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.addChaloPanchayat,
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

  youthJodoCampaign(Map<String, String> data) async {
    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${jsonEncode(data)}]'''));
      Response result = await dioClient.post(Urls.youthJodo,
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

  addProgramLinkApi(Map<String, String> data) async {
    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${jsonEncode(data)}]'''));
      Response result = await dioClient.post(Urls.addProgramlink,
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

  addProgramAttendee(Map<String, String> data) async {
    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${jsonEncode(data)}]'''));
      Response result = await dioClient.post(Urls.addProgramAttendee,
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

  addYIKBForM(Map<String, String> yikbData) async {
    try {
      var data = '''[${jsonEncode(yikbData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.addYIKBData,
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

  addYIKBPayment(Map<String, String> yikbPaymentData) async {
    try {
      var data = '''[${jsonEncode(yikbPaymentData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.addYIKBPayment,
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

  addYIKBCheckPaymentStatus(Map<String, String> yikbPaymentData) async {
    try {
      var data = '''[${jsonEncode(yikbPaymentData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.addYIKBCheckPaymentStatus,
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

  addPehlaVote(Map<String, String> chaloPanchayatData) async {
    try {
      var data = '''[${jsonEncode(chaloPanchayatData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.addPehlaVote,
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

  viewChaloPanchayatData(Map<String, String> chaloPanchayatData) async {
    try {
      var data = '''[${jsonEncode(chaloPanchayatData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.viewYouthJodo,
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

  getReports(String reportType, String campaignId) async {
    var data =
        '''[{"V":"${AppConstants.d2DCampaignVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}","LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
        "STATE_CODE":"${await LocalStorageServices().getWorkStateCode()}",
        "HOME_STATE":"${await LocalStorageServices().getSTCode()}",
        "REPORT_TYPE":"$reportType","CAMPAIGN_ID":"$campaignId"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.campaignReports,
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
