import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';


class ComplaintsRepo {
  DioClient dioClient = sl();

  getCandidatureLevels() async {
    var data = '''[{
    "V":"${AppConstants.complaintsVersion}","ORG":"${AppConstants.orgName}","STATE_CODE":"${await LocalStorageServices().getSTCode()}",
    "MOBILE":"${await LocalStorageServices().getMobile()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getComplaintsLevel,
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

  getNominationComplaint(
      String committeeType,
      String? userState,
      String? userDistrict,
      String? userAssembly,
      String? userBlock,
      String? userMandalam) async {
    var data = '''[{
    "V":"${AppConstants.complaintsVersion}","ORG":"${AppConstants.orgName}","STATE_CODE":"$userState",
    "MOBILE":"${await LocalStorageServices().getMobile()}","DISTRICT_CODE":"$userDistrict","ASSEMBLY_CODE":"$userAssembly","BLOCK_CODE":"$userBlock",
    "MANDALAM_CODE":"$userMandalam","COMMITTEE_TYPE":"$committeeType",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(
          Urls.getComplaintsCandidatesNomination,
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

  addComplaint(
      String committeeType,
      Map candidateData,
      List<String> documentNameList,
      String complaintText,
      String userMemberId) async {
    var data = '''[{
    "V":"${AppConstants.complaintsVersion}","ORG":"${AppConstants.orgName}","STATE_CODE":"${await LocalStorageServices().getSTCode()}",
    "MOBILE":"${await LocalStorageServices().getMobile()}","MEMBER_ID":"$userMemberId",
    "COMPLAINT_TYPE":"NOMINATION",
    "CANDIDATE_ID":"${candidateData["MEMBER_ID"]}","COMPLAINT_TEXT":"$complaintText",
    "COMMITTEE_TYPE":"$committeeType",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "COMPLAINT_DOC_1":"${documentNameList[0]}","COMPLAINT_DOC_2":"${documentNameList[1]}",
    "COMPLAINT_DOC_3":"${documentNameList[2]}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.addComplaint,
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

  checkPaymentStatusComplaints(String transactionId, String amount) async {
    var data = '''[{
         "V":"${AppConstants.complaintsVersion}","ORG":"${AppConstants.orgName}",
         "MOBILE":"${await LocalStorageServices().getMobile()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
"STATE_CODE":"${await LocalStorageServices().getSTCode()}",
    "ORDER_ID":"$transactionId"}]''';

    try {
      var base64encoded = base64.encode(utf8.encode(data));

      final result = await dioClient.post(Urls.getComplaintsPaymentStatus,
          data: base64encoded);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  getMemberDetails() async {
    var data =
        '''[{"V":"${AppConstants.complaintsVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getMemberDetails,
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
