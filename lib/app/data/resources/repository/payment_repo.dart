import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/data_model/nomination_member.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

import '../urls.dart';

class PaymentRepo {
  final DioClient dioClient = sl<DioClient>();

  Future<ApiResponse> getRsaKey(String transactionID) async {
    try {
      //var base64encoded = base64.encode(utf8.encode(uploadDAta));

      final result = await Dio(BaseOptions(headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${AppConstants.authorisationKey}'
      }, responseType: ResponseType.plain))
          .get(
        "https://nsui.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/aggregator/ccavenue/GetRSA.php?access_code=${await LocalStorageServices().getPaymentAccessCode()}&order_id=$transactionID",
      );

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getAllPaymentBatches(Map<String, String> data) async {
    var data = '''[{    "STATE":"${await LocalStorageServices().getSTCode()}",
"V":"${AppConstants.membershipVersion}","PAYMENT_MODE":"ONLINE"}]''';

    try {
      var base64encoded = base64.encode(utf8.encode(data));

      final result = await dioClient.post(
          "https://nsui.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/aggregator/BatchFees.php",
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  initiatePayment(List<Map<String, dynamic>> listData) async {
    String encode = jsonEncode(listData);
    var data =
        '''[{"BATCHES":$encode,"AGGR_ID":"${await LocalStorageServices().getAgrIDMembership()}","V":"${AppConstants.membershipVersion}"}]''';
    //[{"AMOUNT":"50","BATCH_NO":"TS904000184"},{"AMOUNT":"50","BATCH_NO":"TS904000110"}]

    try {
      var base64encoded = base64.encode(utf8.encode(data));

      final result = await dioClient.post(
          "https://nsui.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/aggregator/payment_initiateonline.php",
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  checkTransactionId(Map<String, dynamic> transactionData) async {
    var data =
        '''[{    "AGGR_ID":"${await LocalStorageServices().getAgrIDMembership()}",
"V":"${AppConstants.membershipVersion}",
"TRANSACTION_ID":"${transactionData["transaction_id"]}","AMOUNT":"${transactionData["amount"]}"}]''';
    //[{"AMOUNT":"50","BATCH_NO":"TS904000184"},{"AMOUNT":"50","BATCH_NO":"TS904000110"}]

    try {
      var base64encoded = base64.encode(utf8.encode(data));

      final result = await dioClient.post(
          "https://nsui.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/aggregator/payment_check.php",
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  checkPaymentStatusAggregator(String transactionId) async {
    var data =
        '''[{"V":"${AppConstants.membershipVersion}","AGGR_ID":"${await LocalStorageServices().getAgrIDMembership()}",
        "TRANSACTION_ID":"$transactionId"}]''';

    try {
      var base64encoded = base64.encode(utf8.encode(data));

      final result = await dioClient.post(
          "https://nsui.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/aggregator/payment_status.php",
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  checkPaymentStatusNomination(
      NominationMember member, String transactionId) async {
    var data = '''[{
         "V":"${AppConstants.nominationVersion}","ORG":"${AppConstants.orgName}",
         "MEMBER_ID":"${member.memberId}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
"CHANNEL":"${AppConstants.channel}","NOMINATION_ID":"${member.id}",
    "ORDER_ID":"$transactionId","AMOUNT":"${member.amount}"}]''';

    try {
      var base64encoded = base64.encode(utf8.encode(data));

      final result = await dioClient.post(Urls.getNominationPaymentCheck,
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  addPaymentNomination(NominationMember member, String transactionId) async {
    var data = '''[{
         "V":"${AppConstants.nominationVersion}","ORG":"${AppConstants.orgName}",
         "MEMBER_ID":"${member.memberId}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
"CHANNEL":"${AppConstants.channel}","NOMINATION_ID":"${member.id}",
    "ORDER_ID":"$transactionId","AMOUNT":"${member.amount}"}]''';

    try {
      var base64encoded = base64.encode(utf8.encode(data));

      final result =
          await dioClient.post(Urls.addNominationPayment, data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  initiateAggrPayment(String transactionId, String amount) async {
    var data = '''[{
    "V":"${AppConstants.membershipVersion}","ORG":"${AppConstants.orgName}","SESSION_ID":"${await LocalStorageServices().getSessionId()}",
    "USER_ID":"${await LocalStorageServices().getUserId()}",
    "DEVICE_ID":"${await getDeviceIdentifier()}",
   "LATITUDE":"${sl<LocationProvider>().currentLocation!.latitude}","LONGITUDE":"${sl<LocationProvider>().currentLocation!.longitude}",
    "ORDER_NUMBER":"$transactionId","AMOUNT":"$amount"
    }]''';

    try {
      var base64encoded = base64.encode(utf8.encode(data));

      final result = await DioClient.second().post(
          "https://nsui.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/aggregator/ccavenue/initiateAggrPayment.php",
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
