import 'package:dio/dio.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';
class SocialFeedsRepo {
  final DioClient dioClient;
  CancelToken? cancelToken;

  /// for getting iyc social youtube
  /// commnet.
  SocialFeedsRepo({required this.dioClient, CancelToken? cancelToken});

  /// uses cance token
  Future getSocialFeeds() async {
    try {
      Response result = await dioClient.get(
          "https://nsui.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/iyc_social/getSocialFeeds.php",
          options: Options(
            contentType: Headers.textPlainContentType,
            responseType: ResponseType.plain,
            receiveDataWhenStatusError: true,
          ),
          cancelToken: cancelToken);

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
