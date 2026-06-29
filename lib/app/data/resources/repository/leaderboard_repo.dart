import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/provider/global/location_provider.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';import 'package:iyc/app/data/resources/services/local_storage_services.dart';import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/utils/app_constants.dart';
import 'package:iyc/utils/utils.dart';

class LeaderBoardRepo{
  DioClient dioClient = sl();

  getPointStatement(String month, String year) async {
    var data =
    '''[{
        "V":"${AppConstants.rewardsVersion}",
        "ORG":"${AppConstants.orgName}",
        "SESSION_ID":"${await LocalStorageServices().getSessionId()}",
        "DEVICE_ID":"${await getDeviceIdentifier()}",
        "USER_ID":"${await LocalStorageServices().getUserId()}",
        "LATITUDE":"${sl<LocationProvider>().currentLocation?.latitude ?? 0.0000}",
        "LONGITUDE":"${sl<LocationProvider>().currentLocation?.longitude ?? 0.0000}",
        "MONTH":"$month",
        "YEAR":"$year"
        }]''';
    try {
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.getPointStatement,
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