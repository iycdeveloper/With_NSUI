import 'package:dio/dio.dart';
import 'package:iyc/di_container.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/app/data/resources/remote/dio/dio_client.dart';import 'package:iyc/app/data/resources/remote/exception/api_error_handler.dart';

class TwitterRepo {
  final DioClient dioClient = sl<DioClient>();

  Future<ApiResponse> getTwitterFeedList(
      {String? nextToken, required bool nextFeed}) async {
    String twitterFeedCount = "10";
    // String bearerrTokentestakj =
    //     "AAAAAAAAAAAAAAAAAAAAADT0QAEAAAAAIfkIDshLPCtMS9FpF8Ag9JfrKiY%3DMHBwvJjLE0UMfgWE8GV7gLz4DhBFgxNJj0IFMWjBW4wXYgrjkz";
    String bearerrTokenUWC =
        "AAAAAAAAAAAAAAAAAAAAADT0QAEAAAAAIfkIDshLPCtMS9FpF8Ag9JfrKiY%3DMHBwvJjLE0UMfgWE8GV7gLz4DhBFgxNJj0IFMWjBW4wXYgrjkz";
    String userIdUwc = "1262695055153717249";
    try {
      final response;
      if (nextFeed) {
        response = await dioClient.get(
          "https://api.twitter.com/2/users/$userIdUwc/tweets?expansions=attachments.media_keys,author_id&tweet.fields=public_metrics,created_at&user.fields=created_at,name,profile_image_url,public_metrics,username&max_results=${twitterFeedCount}&media.fields=public_metrics,type,url&pagination_token=${nextToken}",
          options:
              Options(headers: {"Authorization": "Bearer ${bearerrTokenUWC}"}),
        );
      } else {
        response = await dioClient.get(
          "https://api.twitter.com/2/users/$userIdUwc/tweets?expansions=attachments.media_keys,author_id&tweet.fields=public_metrics,created_at&user.fields=created_at,name,profile_image_url,public_metrics,username&max_results=${twitterFeedCount}&media.fields=public_metrics,type,url",
          options:
              Options(headers: {"Authorization": "Bearer ${bearerrTokenUWC}"}),
        );
      }
      print("ress-------");

      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
