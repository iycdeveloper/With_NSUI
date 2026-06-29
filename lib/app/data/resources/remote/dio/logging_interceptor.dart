import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:iyc/model/offline_model/database/iyc_log.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  int maxCharactersPerLine = 200;

  static bool isBase64(dynamic value) {
    if (value.runtimeType == String) {
      final RegExp rx = RegExp(
        r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$',
        multiLine: true,
        unicode: true,
      );

      final bool isBase64Valid = rx.hasMatch(value);

      if (isBase64Valid == true) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (kDebugMode) {
      print("--> ${options.method} ${options.path}");
      // print("Headers: ${options.headers.toString()}");

      if (options.data != null) if (options.data is Map<String, dynamic>) {
        print("data: ${options.data}");
        IycLog.log(
            title: " ${options.method} ${options.path}",
            status: "API_SUCCESS",
            content: "data: ${options.data}",
            createdOn: DateTime.now().toIso8601String());
      } else {
        print("data: ${utf8.decode(base64Decode(options.data)).toString()}");
        IycLog.log(
            title: " ${options.method} ${options.path}",
            status: "API_SUCCESS",
            content:
                "data: ${utf8.decode(base64Decode(options.data)).toString()}",
            createdOn: DateTime.now().toIso8601String());
      }
      print("--> END HTTP");
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) {
      print(
          "<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");

      String responseAsString = '';
      try {
        responseAsString = isBase64(response.data)
            ? utf8.decode(base64Decode(response.data.toString()))
            : response.data.toString();
      } on Exception catch (e) {
        print(e);
      }

      if (responseAsString.length > maxCharactersPerLine) {
        int iterations =
            (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          print(responseAsString.substring(
              i * maxCharactersPerLine, endingIndex));
        }
      } else {
        try {
          print(utf8.decode(base64Decode(response.data)).toString());
        } on Exception catch (e) {
          print(response.data);
        }
      }

      print("<-- END HTTP");
    }

    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    if (kDebugMode)
      print(
          "ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    return super.onError(err, handler);
  }
}
