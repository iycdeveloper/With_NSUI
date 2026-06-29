import 'package:hive/hive.dart';
import 'package:iyc/model/api_model/social/twitter_response.dart';

part 'twitter_feed_model.g.dart';

@HiveType(typeId: 1)
class TwitterFeedModel{
  @HiveField(0)
  final String? text;
  @HiveField(1)
  final String? url;
  @HiveField(2)
  final String? profileImageUrl;
  @HiveField(3)
  final String? name;
  @HiveField(4)
  final String? date;

  TwitterFeedModel({required this.text,this.url,this.name,this.profileImageUrl,this.date});

}