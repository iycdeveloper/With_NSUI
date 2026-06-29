import 'package:dio/dio.dart';

class ApiResponse {
  final Response? response;
  final dynamic error;

  ApiResponse(this.response, this.error);

  ApiResponse.withError(dynamic errorValue)
      : response = null,
        error = errorValue;

  ApiResponse.withSuccess(Response responseValue)
      : response = responseValue,
        error = null;
}

class NewApiResponse {
  final dynamic data;
  final dynamic error;

  NewApiResponse(this.data, this.error);

  NewApiResponse.withError(dynamic errorValue)
      : data = null,
        error = errorValue;

  NewApiResponse.withSuccess(dynamic responseValue)
      : data = responseValue,
        error = null;
}
