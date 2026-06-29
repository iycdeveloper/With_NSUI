import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';
import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
import 'package:iyc/app/data/resources/urls.dart';
import 'package:iyc/utils/app_constants.dart';

class BpycRepo {
    DioClient dioClient = sl();

  viewCPYcPanchayat(Map<String, String> chaloPanchayatData) async {
    try {
      var data = '''[${jsonEncode(chaloPanchayatData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.viewBPYC,
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
  viewMemberCPYcPanchayat(Map<String, String> chaloPanchayatData) async {
    try {
      var data = '''[${jsonEncode(chaloPanchayatData)}]''';
      var base64encoded = base64.encode(utf8.encode(data));
      Response result = await dioClient.post(Urls.viewMemberBPYC,
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

  addCPyC(Map<String, String> data) async {
    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${jsonEncode(data)}]'''));
      Response result = await dioClient.post(Urls.addBPYC,
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

  addMemberCPyC(Map<String, String> data) async {
    try {
      var base64encoded =
          base64.encode(utf8.encode('''[${jsonEncode(data)}]'''));
      Response result = await dioClient.post(Urls.addMemberBPYC,
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
