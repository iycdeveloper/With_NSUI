import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
import 'package:iyc/app/data/resources/services/local_storage_services.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

import '../../../../di_container.dart';
import '../urls.dart';

class PollingRepo {
  DioClient dioClient;
  PollingRepo({required this.dioClient});

  Future<Map<String, dynamic>> _commonFields() async => {
        "V": AppConstants.nominationVersion,
        "ORG": AppConstants.orgName,
        "SESSION_ID": await LocalStorageServices().getSessionId(),
        "USER_ID": await LocalStorageServices().getUserId(),
        "DEVICE_ID": await getDeviceIdentifier(),
        "LATITUDE":
            "${sl<LocationProvider>().currentLocation?.latitude ?? ''}",
        "LONGITUDE":
            "${sl<LocationProvider>().currentLocation?.longitude ?? ''}",
      };

  Future<ApiResponse> _post(String endpointUrl, Map<String, dynamic> fields) async {
    try {
      var data = jsonEncode([fields]);
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(endpointUrl,
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

  Future<ApiResponse> checkPhase2PollingAccess() async {
    return _post(Urls.checkPhase2PollingAccess, await _commonFields());
  }

  Future<ApiResponse> getPhase2Candidate({required String ballot}) async {
    var fields = await _commonFields();
    fields["BALLOT"] = ballot;
    return _post(Urls.getPhase2Candidate, fields);
  }

  Future<ApiResponse> pollingPhase2(
      {required String csnSp, required String csnDp}) async {
    var fields = await _commonFields();
    fields["CSN_SP"] = csnSp;
    fields["CSN_DP"] = csnDp;
    return _post(Urls.pollingPhase2, fields);
  }
}
