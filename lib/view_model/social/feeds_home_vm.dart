import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iyc/helper/network_config.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/social/twitter_response.dart';
import 'package:iyc/model/data_model/feed_item_model.dart';
import 'package:iyc/model/offline_model/twitter_feed_model.dart';
import 'package:iyc/app/data/resources/repository/facebook_repo.dart';
import 'package:iyc/app/data/resources/repository/twitter_repo.dart';
import 'package:iyc/app/data/resources/repository/social_feeds_repo.dart';

import '../../di_container.dart';

class FeedsHomeVM extends ChangeNotifier {
  final TwitterRepo twitterRepo = TwitterRepo();
  final NetworkConfig networkConfig = sl<NetworkConfig>();
  final FacebookRepo facebookRepo = FacebookRepo();

  List<FeedItemModel> feedList = [];

  TwitterResponse? twitterResponse;
  Box<TwitterFeedModel> twitterFeedBox = Hive.box("twitter_feed");
  List<TwitterFeedModel> twitterFeedFromHive = [];
  String nextToken = "";

  CancelToken? _ytFeedCancelToken;

  @override
  void dispose() {
    _ytFeedCancelToken?.cancel();
  }

  cancelByToken() async => _ytFeedCancelToken?.cancel();

  getTwitterFeedFromLocal() {
    twitterFeedFromHive = twitterFeedBox.values.toList();
    notifyListeners();
  }

  initFeeds(BuildContext context) async {
    if (await networkConfig.isConnected) {
      Future.wait([
        //   getTwitterFeeds(context),
        getSocialFeeds(context),
      ]);

      print("----sort");
      feedList.sort(
          (b, a) => DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));
      feedList.toSet().toList();
      notifyListeners();
    } else {
      /// to do offline feeds
    }
  }

  Future<bool> getSocialFeeds(BuildContext context) async {
    _ytFeedCancelToken ??= CancelToken();
    ApiResponse apiResponse =
        await SocialFeedsRepo(dioClient: sl(), cancelToken: _ytFeedCancelToken)
            .getSocialFeeds();

    bool returnValue = false;
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final responseDecoded =
          jsonDecode(utf8.decode(base64Decode(apiResponse.response!.data)));
      if (responseDecoded['status'] == "SUCCESS") {
        SocialFeed socialFeed = SocialFeed.fromJson(responseDecoded);
        feedList = socialFeed.response.facebook!;
        feedList.addAll(socialFeed.response.youtube!);

        returnValue = true;
        //  Navigator.of(context).pop();

      } else {
        //  Navigator.of(context).pop();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(responseDecoded["response"])));
        returnValue = false;
      }
      _ytFeedCancelToken = null;
      notifyListeners();
    } else {
      //  Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(apiResponse.error.toString())));
      returnValue = false;
    }

    return returnValue;
  }

  //  Future<bool> getFBLoopFeeds(BuildContext context) async {
//     for (int i = 0; i < 4; i++) {
//       if (i == 0) {
//         // print( getFacebookFeeds(context,url: Urls.fbToken1));
//       } else if (i == 1) {
//         print(await getFacebookFeeds(context, url: Urls.fbToken2));
//       } else if (i == 2) {
//         print(await getFacebookFeeds(context, url: Urls.fbToken3));
//       } else if (i == 3) {
//         print(await getFacebookFeeds(context, url: Urls.fbToken4));
//       } else if (i == 4) {
//         print(await getFacebookFeeds(context, url: Urls.fbToken5));
//       }
//     }
//     return true;
//   }
  Future<bool> getTwitterFeeds(BuildContext context) async {
    bool returnStatus = false;

    ApiResponse apiResponse = await twitterRepo.getTwitterFeedList(
      nextFeed: false,
    );
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      twitterResponse = TwitterResponse.fromJson(apiResponse.response!.data);
      // print("lengthh");
      // debugPrint(twitterResponse!.includes!.media!.length.toString());
      // debugPrint(twitterResponse!.data!.length.toString());

      //    twitterResponse!.data!.forEach((element) async{

      for (int i = 0; i < twitterResponse!.data!.length; i++) {
        //  debugPrint(twitterResponse!.includes!.media![i].mediaKey);
        // print(twitterResponse!.data![i].id);
        // print("next token");
        // print(twitterResponse!.meta!.nextToken);

        // TwitterFeedModel(
        //     text: twitterResponse!.data![i].text,
        //     name: twitterResponse!.includes!.users!.first.name,
        //     profileImageUrl:
        //         twitterResponse!.includes!.users!.first.profileImageUrl,
        //     url: twitterResponse!.includes!.media!.length > i
        //         ? twitterResponse!.includes!.media![i].url
        //         : "",
        //     date: twitterResponse!.data![i].createdAt.toString()));

        feedList.add(FeedItemModel(
            feedType: "TWITTER",
            postContent: twitterResponse!.data![i].text,
            contentUrl: twitterResponse!.includes!.media!.length > i
                ? twitterResponse!.includes!.media![i].url
                : "",
            date: twitterResponse!.data![i].createdAt.toString()));
      }
      // twitterFeedFromHive.sort((a, b) {
      //   // print("dateee");
      //   // print(a.date);
      //
      //   DateTime adate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(a.date!);
      //   DateTime bdate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(b.date!);
      //   return -adate.compareTo(bdate);
      // });
      returnStatus = true;
      notifyListeners();
    } else {
      returnStatus = false;
      //     ApiChecker.checkApi(context, apiResponse);
      notifyListeners();
    }
    return returnStatus;
  }

// getFacebookFeeds(BuildContext context, {required String url}) async {
  //   ApiResponse apiResponse = await facebookRepo.getFacebookFeeds(url: url);
  //   print(apiResponse);
  //   print("res");
  //   bool returnValue = false;
  //   if (apiResponse.response != null && apiResponse.error == null) {
  //     final responseDecoded = jsonDecode(apiResponse.response!.data);
  //     print(responseDecoded);
  //
  //     FacebookResponse facebookResponse =
  //         FacebookResponse.fromJson(responseDecoded);
  //
  //     facebookResponse.data!.forEach((element) {
  //       feedList.add(FeedItemModel(
  //           feedType: "FACEBOOK",
  //           id: element.id,
  //           postContent: element.message,
  //           date: element.createdTime,
  //           contentUrl: element.attachments.data!.first.url ?? "",
  //           mediaType: element.attachments.data!.first.type == "video_inline"
  //               ? costVideoType
  //               : costImageType,
  //           thumbNailUrl: element.fullPicture));
  //     });
  //     print(feedList.length);
  //     returnValue = true;
  //     //  Navigator.of(context).pop();
  //     notifyListeners();
  //   } else {
  //     //  Navigator.of(context).pop();
  //     try {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(apiResponse.error.toString())));
  //     } on Exception catch (e) {
  //       print(e);
  //     }
  //     returnValue = false;
  //   }
  //
  //   return returnValue;
  // }
}
