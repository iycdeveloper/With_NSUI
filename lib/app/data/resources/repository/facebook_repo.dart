import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';import 'package:iyc/utils/app_constants.dart';

class FacebookRepo {
  final DioClient dioClient = sl<DioClient>();

  FacebookRepo();

  Future getFacebookFeeds({required String url}) async {
    try {
      print(
        url + "${AppConstants.facebookAccessToken}",
      );
      Response result = await dioClient.get(
        url + "${AppConstants.facebookAccessToken}",
        options: Options(
          contentType: Headers.textPlainContentType,
          responseType: ResponseType.plain,
          receiveDataWhenStatusError: true,
        ),
      );

      return ApiResponse.withSuccess(result);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
