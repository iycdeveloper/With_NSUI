import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';
import '../remote/dio/dio_client.dart';
import '../remote/exception/api_error_handler.dart';
import '../services/local_storage_services.dart';
import '../urls.dart';

class RoRepo {
  DioClient? dioClient;

  getRoDetails() async {
    var data =
        '''[{"V":"${AppConstants.roVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient!.post(Urls.roDetails,
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

  checkRoPayment(String mobile) async {
    var data =
        '''[{"V":"${AppConstants.roVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "MOBILE_PAYEE":"$mobile"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient!.post(Urls.roPaymentStatus,
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

  roSearchMember(String roId, String searchData) async {
    var data =
    '''[{"V":"${AppConstants.roVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "RO_ID":"$roId",
        "SEARCH_DATA":"$searchData"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient!.post(Urls.roSearchMember,
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

  getNomination({
    String? roId,
    String? ballot,
    String? state,
    String? district,
    String? assembly,
    String? mandalam
  }) async {
    var data =
    '''[{"V":"${AppConstants.roVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "RO_ID":"$roId",
        "BALLOT":"$ballot",
        "STATE_CODE":"$state",
        "DISTRICT_CODE":"$district",
        "ASSEMBLY_CODE":"$assembly",
        "MANDALAM_CODE":"$mandalam"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient!.post(Urls.roGetNomination,
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

  getMembership({
    String? roId
  }) async {
    var data =
    '''[{"V":"${AppConstants.roVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "RO_ID":"$roId"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient!.post(Urls.roGetAM,
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

  getRoStats({
    String? roId
  }) async {
    var data =
    '''[{"V":"${AppConstants.roVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "RO_ID":"$roId"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient!.post(Urls.roStats,
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

  updateNominationStatus(String roId, String memberId, String nominationStatus, String remark) async {
    var data =
    '''[{"V":"${AppConstants.roVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "RO_ID":"${roId}",
        "MEMBER_ID":"${memberId}",
        "NOMINATION_STATUS":"${nominationStatus}",
        "REMARK":"$remark"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient!.post(Urls.roUpdateNominationStatus,
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

  editNominationDetails(Map<String, String> dataMap) async {
     var baseDataMap = {
      "V": AppConstants.roVersion,
      "ORG": AppConstants.orgName,
      "SESSION_ID": await LocalStorageServices().getSessionId(),
      "DEVICE_ID": await getDeviceIdentifier(),
      "USER_ID": await LocalStorageServices().getUserId(),
      "LATITUDE": "${sl<LocationProvider>().currentLocation!.latitude}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation!.longitude}"
    };
    baseDataMap.addAll(dataMap);
    try {
      var base64encoded = base64.encode(utf8.encode('''[${json.encode(baseDataMap)}]'''));
      Response result = await dioClient!.post(Urls.roEditNomination,
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


  updateMembershipStatus(String roId, String memberId, String nominationStatus, String remark) async {
    var data =
    '''[{"V":"${AppConstants.roVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "RO_ID":"${roId}",
        "MEMBER_ID":"${memberId}",
        "RO_STATUS":"${nominationStatus}",
        "REMARK":"$remark"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient!.post(Urls.roUpdateMemberStatus,
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
