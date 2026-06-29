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

class MembershipRepo {
  final DioClient dioClient;
  MembershipRepo({required this.dioClient});

  Future downloadMembers(String batchId) async {
//"AGGR_ID":"${await LocalStorageServices().getAgrID()}",
    var data = '''[{
    "AGGR_ID":"${await LocalStorageServices().getAgrIDMembership()}",
    "BATCH_NO":"${batchId}",
    "V":"${AppConstants.membershipVersion}",
    "CHANNEL":"${AppConstants.channel}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
    "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "STATE_CODE":"${await LocalStorageServices().getSTCode()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}"
    }]''';
    //"TS902000007" batch id
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.agrDownloadMembers,
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

  Future<NewApiResponse> getINCUserDetails(String memberId) async {
    var testJsonData =
        '''[{"V":"${AppConstants.membershipVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}","DEVICE_ID":"${await getDeviceIdentifier()}","USER_ID":"${await LocalStorageServices().getUserId()}","LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}","INC_MEMBER_ID":"$memberId"}]''';
    try {
      var base64encoded = base64.encode(utf8.encode(testJsonData));

      final apiResponse =
          await dioClient.post(Urls.getINCUserDetails, data: base64encoded);
      if (apiResponse.data != null && apiResponse.statusCode == 200) {
        final responseDecoded =
            jsonDecode(utf8.decode(base64Decode(apiResponse.data)));

        if (responseDecoded['status'] == "SUCCESS") {
          return NewApiResponse.withSuccess(responseDecoded["response"]);
        } else {
          return NewApiResponse.withError(responseDecoded["response"]);
        }
      } else {
        return NewApiResponse.withError("unimplemented");
      }
    } catch (e) {
      return NewApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future validateEpicId(String stateCode, String id) async {
    var data = '''[{
      "V": "${AppConstants.membershipVersion}",
      "ORG": "${AppConstants.orgName}",
      "SESSION_ID": "${await LocalStorageServices().getSessionId()}",
      "DEVICE_ID": "${await getDeviceIdentifier()}",
      "USER_ID": "${await LocalStorageServices().getUserId()}",
      "LATITUDE": "${sl<LocationProvider>().currentLocation?.latitude ?? "0.0"}",
      "LONGITUDE": "${sl<LocationProvider>().currentLocation?.longitude ?? "0.0"}",
      "STATE_CODE":"$stateCode",
      "EPIC":"${id}"
    }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(
          'https://api.iyc.in/ycea/ycea-api/service/nsui/api/v1.0/aggregator/epicCheck.php',
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

  getNominationBallotData(
      {
      String? ballot,
      String? state,
      String? district,
      String? assembly,
      String? mandalam,
      String? blackCode,
      String? boothCode
      
      }) async {
    var data = '''[{"V":"${AppConstants.membershipVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
        "BALLOT":"$ballot",
        "STATE_CODE":"$state",
        "DISTRICT_CODE":"$district",
        "ASSEMBLY_CODE":"$assembly",
        "MANDALAM_CODE":"$mandalam",
        "BLOCK_CODE":"$blackCode",
        "BOOTH_CODE":"$boothCode"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getNominationBallotdataList,
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
  //  Future<ApiResponse> addMembership(
//       {required List membershipRequestList}) async {
//     // "LATITUDE": "3.989234383434343",
//     // "LONGITUDE": "9.034342423423",
//     // "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
//     // "USER_ID": "${await LocalStorageServices().getUserId()}",
//     //    "CHANNEL":"${AppConstants.channel}",
//     var data =
//         '''[{"MEMBER_DATA":[{"ADDRESS":"${membershipRequestList.first['ADDRESS']}","EMAIL":"${membershipRequestList.first['EMAIL']}","MOBILE1":"${membershipRequestList.first['MOBILE1']}","LAST_NAME":"${membershipRequestList.first['LAST_NAME']}","FIRST_NAME":"${membershipRequestList.first['FIRST_NAME']}","MEMBER_ID":"TS90400010901","ORGANIZATION_CODE":"IYC","CREATED_BY":"","AGGR_ID":"${await LocalStorageServices().getAgrIDMembership()}","BATCH_NO":"${membershipRequestList.first['BATCH_NO']}","TMP_ID":"1639029881203","DEVICE_ID":"67d9bf22-2385-4022-afba-702bf7c8c714","VERIFICATION_CODE":"259360","REFERRER_ID":"","ID_VALUE":"dghhjk","ID_TYPE":"${membershipRequestList.first['ID_TYPE']}","BOOTH_CODE":"0004","ASSEMBLY_CODE":"88","DISTRICT_CODE":"${membershipRequestList.first['DISTRICT_CODE']}","STATE_CODE":"${membershipRequestList.first['STATE_CODE']}","RELATIVE_NAME":"Father nNw","DATE_OF_BIRTH":"23-12-1986","CATEGORY_CODE":"${membershipRequestList.first['CATEGORY_CODE']}","SEX_CODE":"${membershipRequestList.first['SEX_CODE']}","CITY":"Graduate","PINCODE":"${membershipRequestList.first['PINCODE']}","MANDALAM_CODE":"","PROFESSION":"${membershipRequestList.first['PROFESSION']}","CSN_SP":"${membershipRequestList.first['CSN_SP']}","CSN_DP":"${membershipRequestList.first['CSN_DP']}","CSN_AP":"${membershipRequestList.first['CSN_AP']}","CSN_SG":"${membershipRequestList.first['CSN_SG']}","EDUCATION":"${membershipRequestList.first['EDUCATION']}","BLOCK_CODE":"","CHANNEL":"M","RELATION_CODE":"F"}],
//     "BATCH_NO":"${membershipRequestList.first['BATCH_NO']}",
//     "AGGR_ID":"${await LocalStorageServices().getAgrIDMembership()}",
//     "V":"${AppConstants.membershipVersion}"}]''';
//
//     try {
//       print(data);
//       var latinEncoded = latin1.encode(data);
//       var base64encoded = base64.encode(latinEncoded);
//       final result = await dioClient.post(Urls.syncBatch,
//           options: Options(
//             contentType: Headers.textPlainContentType,
//             responseType: ResponseType.plain,
//             // headers: {
//             //   "Authorization": "Bearer 72c831476bfc479d:4efb65f092ac72c83147",
//             //   "token": "${await LocalStorageServices().getSessionId()}"
//             // },
//             receiveDataWhenStatusError: true,
//           ),
//           data: base64encoded);
//       print(result.data);
//       var latinDecoded = base64.decode(result.data);
//       var responseDataDecoded = latin1.decode(latinDecoded);
//       final finalResult = json.decode(responseDataDecoded);
//
//       print(finalResult);
//       if (result.statusCode == 200 && finalResult["status"] == "SUCCESS")
//         return ApiResponse.withSuccess(finalResult);
//       return Future.error("Not available");
//     } catch (e) {
//       print("--");
//       print(e);
//       return ApiResponse.withError(ApiErrorHandler.getMessage(e));
//     }
//   }
}
