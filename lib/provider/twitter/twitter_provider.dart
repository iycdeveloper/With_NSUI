import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:iyc/helper/api_checker.dart';
import 'package:iyc/helper/network_config.dart';
import 'package:iyc/model/api_model/base/api_response.dart';
import 'package:iyc/model/api_model/social/twitter_response.dart';
import 'package:iyc/model/offline_model/twitter_feed_model.dart';
import 'package:iyc/app/data/resources/repository/twitter_repo.dart';

class TwitterProvider extends ChangeNotifier {
  final TwitterRepo twitterRepo;
  final NetworkConfig networkConfig;
  TwitterProvider({required this.twitterRepo,required this.networkConfig});

  TwitterResponse? twitterResponse;
  Box<TwitterFeedModel> twitterFeedBox = Hive.box("twitter_feed");
  List<TwitterFeedModel> twitterFeedFromHive = [];
  String nextToken="";
  getTwitterFeedFromLocal(){
    twitterFeedFromHive = twitterFeedBox.values.toList();
    notifyListeners();
  }
  getTwitterFeedList(
      BuildContext context, bool reload, String languageCode,{required bool nextFeed}) async {

    if (!await networkConfig.isConnected) {
      /// Mobile is not Connected to Internet
      twitterFeedFromHive = twitterFeedBox.values.toList();
      notifyListeners();
    } else if (await networkConfig.isConnected) {
      print("network connectyed");
      print("api called");
      // print(nextToken);
       // twitterFeedBox.clear();
      // twitterFeedFromHive.clear();

      if (twitterResponse == null || reload||nextFeed) {
        //TODO:1 split code to TwitterRepoLocal saving to box and fetching from hive, two functions in it
        // flow will initialy using twitter repo fetch all twtter feeds save it hive by twitter repo local
        // fetch data from twitter repo local
        // populate twitterfeedsLIst , notify listerners

        //TODO:2 implement a logic save into twitterbox with a unique id twitterpost id
        // then implement a logic checking each time when new data availble
        // delete the old data that are not present in the new list with comparing
        // twitter id of post and also evict that posts url from cached network  image
        // so it will always posts saved 100 only .

        //TODO:3 implement pagination of twitter feeds
        ApiResponse apiResponse = await twitterRepo.getTwitterFeedList(nextFeed: nextFeed,nextToken: nextToken);
        if (apiResponse.response != null &&
            apiResponse.response!.statusCode == 200) {
          twitterResponse =
              TwitterResponse.fromJson(apiResponse.response!.data);
          // print("lengthh");
          // debugPrint(twitterResponse!.includes!.media!.length.toString());
          // debugPrint(twitterResponse!.data!.length.toString());

          //    twitterResponse!.data!.forEach((element) async{
          for (int i = 0; i < twitterResponse!.data!.length; i++) {
          //  debugPrint(twitterResponse!.includes!.media![i].mediaKey);
            // print(twitterResponse!.data![i].id);
            // print("next token");
            // print(twitterResponse!.meta!.nextToken);

            nextToken=twitterResponse!.meta!.nextToken??"";
            await twitterFeedBox.put(
                twitterResponse!.data![i].id,
                TwitterFeedModel(
                    text: twitterResponse!.data![i].text,
                    name: twitterResponse!.includes!.users!.first.name,
                    profileImageUrl:
                        twitterResponse!.includes!.users!.first.profileImageUrl,
                    url:twitterResponse!.includes!.media!.length>i?
                    twitterResponse!.includes!.media![i].url:"",
                date: twitterResponse!.data![i].createdAt.toString()));
          }
          twitterFeedFromHive = twitterFeedBox.values.toList();
          twitterFeedFromHive .sort((a,b) {
            // print("dateee");
            // print(a.date);

            DateTime adate =  DateFormat("yyyy-MM-dd hh:mm:ss").parse(a.date!);
            DateTime bdate =   DateFormat("yyyy-MM-dd hh:mm:ss").parse(b.date!);
            return -adate.compareTo(bdate);
          });
          notifyListeners();
        } else {
          ApiChecker.checkApi(context, apiResponse);
          notifyListeners();
        }
      }
    }
  }
}
