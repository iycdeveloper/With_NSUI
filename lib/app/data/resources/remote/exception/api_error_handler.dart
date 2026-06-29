import 'package:dio/dio.dart';
import 'package:iyc/model/api_model/base/error_response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "An unexpected error occurred";

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioExceptionType.unknown:
          errorDescription = "Connection to API server failed due to internet connection";
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioExceptionType.badResponse:
        // Safely access the response and handle null cases
          if (error.response != null) {
            switch (error.response!.statusCode) {
              case 404:
              case 500:
              case 503:
              case 401:
                errorDescription = error.response!.statusMessage ?? "Unknown API error";
                break;
              default:
                try {
                  // Ensure proper parsing of error data
                  ErrorResponse errorResponse = ErrorResponse.fromJson(error.response!.data);
                  if (errorResponse.errors != null && errorResponse.errors.isNotEmpty) {
                    errorDescription = errorResponse.errors.join(", ");
                  } else {
                    errorDescription = "Failed to load data - status code: ${error.response!.statusCode}";
                  }
                } catch (e) {
                  errorDescription = "Failed to parse error response: $e";
                }
            }
          } else {
            errorDescription = "No response from server";
          }
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = "Send timeout with server";
          break;
        default:
          errorDescription = "Network not Available";//An unknown Dio error occurred
          break;
      }
    } else if (error is FormatException) {
      errorDescription = "Data format error: ${error.message}";
    } else {
      errorDescription = "Unexpected error occurred: ${error.toString()}";
    }

    return errorDescription;
  }
}
