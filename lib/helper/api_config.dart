import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/base/error_response.dart';
import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
import 'package:iyc/utils/app_constants.dart';

import 'network_config.dart';

class ApiConfig {
  final Dio client;
  final NetworkConfig networkConfig;

  ApiConfig({
    required this.client,
    required this.networkConfig,
  });

  Future<ApiResponse> postData({
    required String endpointUrl,
    required var jsonData,
    // required String apiKey,
  }) async {
    // if (!await networkConfig.isConnected) {
    //   return ApiResponse.withError((Errors.networkError()));
    // }
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.first == ConnectivityResult.none) {
      return ApiResponse.withError((Errors.networkError()));
    }

    try {
      var base64encoded = base64.encode(utf8.encode(jsonData));
      print(base64encoded);
      Response result = await client.post(endpointUrl,
          options: Options(
            contentType: Headers.textPlainContentType,
            responseType: ResponseType.plain,
            receiveDataWhenStatusError: true,
            headers: {
              "Accept": "application/json",
              "Authorization": " Bearer ${AppConstants.authorisationKey}",
            },
          ),
          data: base64encoded);
      return ApiResponse.withSuccess(result);
    } on DioError catch (dioError) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(dioError));
    } catch (e) {
      var err = Errors.unknownError(
        "Oops something went wrong",
        code: e.toString(),
      );
      return ApiResponse.withError("Oops something went wrong");
    }
  }
}
