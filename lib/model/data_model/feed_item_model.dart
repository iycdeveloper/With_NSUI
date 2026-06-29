import 'dart:convert';

import 'package:iyc/utils/text_constants.dart';

class FeedItemModel {
  String feedType;
  String? id;
  String? titleName;
  String? postContent;
  String? contentUrl;
  String? date;
  String? mediaType;
  String? youtubeVideoId;
  String? thumbNailUrl;
  String? description;
  FeedItemModel(
      {required this.feedType,
      this.id,
      this.titleName,
      this.postContent,
      this.contentUrl,
      this.date,
      this.youtubeVideoId,
      this.thumbNailUrl,
      this.description,
      this.mediaType});

  factory FeedItemModel.fromJsonFb(Map<String, dynamic> json) => FeedItemModel(
        id: json["id"],
        feedType: "FACEBOOK",
        postContent: json["message"],
        date: json["created_on"],
        contentUrl: json["url"],
        mediaType: (json["type"] == "album" || json["type"] == "photo")
            ? costImageType
            : costVideoType,
        thumbNailUrl: json["full_picture"],
        titleName: "Indian Youth Congress",
      );

  factory FeedItemModel.fromJsonYT(Map<String, dynamic> json) => FeedItemModel(
        id: json["id"],
        feedType: "YOUTUBE",
        description: json["title"],
        youtubeVideoId: json["videoId"],
        date: json["created_on"],
        contentUrl: json["url"],
        thumbNailUrl: json["thumbnail"],
        titleName: json["channelTitle"],
      );
}

// To parse this JSON data, do
//
//     final socialFeed = socialFeedFromJson(jsonString);

SocialFeed socialFeedFromJson(String str) =>
    SocialFeed.fromJson(json.decode(str));

class SocialFeed {
  SocialFeed({
    required this.status,
    required this.response,
  });

  String status;
  Response response;

  factory SocialFeed.fromJson(Map<String, dynamic> json) => SocialFeed(
        status: json["status"],
        response: Response.fromJson(json["response"]),
      );
}

class Response {
  Response({
    this.youtube,
    this.facebook,
  });

  List<FeedItemModel>? youtube;
  List<FeedItemModel>? facebook;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        youtube: List<FeedItemModel>.from(
            json["YOUTUBE"].map((x) => FeedItemModel.fromJsonYT(x))),
        facebook: List<FeedItemModel>.from(
            json["FACEBOOK"].map((x) => FeedItemModel.fromJsonFb(x))),
      );
}
