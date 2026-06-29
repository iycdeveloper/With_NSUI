// To parse this JSON data, do
//
//     final twitterResponse = twitterResponseFromJson(jsonString);

import 'dart:convert';

TwitterResponse twitterResponseFromJson(String str) =>
    TwitterResponse.fromJson(json.decode(str));

class TwitterResponse {
  TwitterResponse({
    this.data,
    this.includes,
    this.meta,
  });

  final List<TwitterData>? data;
  final Includes? includes;
  final Meta? meta;

  factory TwitterResponse.fromJson(Map<String, dynamic> json) =>
      TwitterResponse(
        data: json["data"] == null
            ? null
            : List<TwitterData>.from(
                json["data"].map((x) => TwitterData.fromJson(x))),
        includes: json["includes"] == null
            ? null
            : Includes.fromJson(json["includes"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );
}

class TwitterData {
  TwitterData({
    this.createdAt,
    this.text,
    this.id,
    this.authorId,
    this.publicMetrics,
    this.attachments,
  });

  final DateTime? createdAt;
  final String? text;
  final String? id;
  final String? authorId;
  final DatumPublicMetrics? publicMetrics;
  final Attachments? attachments;

  factory TwitterData.fromJson(Map<String, dynamic> json) => TwitterData(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        text: json["text"] == null ? null : json["text"],
        id: json["id"] == null ? null : json["id"],
        authorId: json["author_id"] == null ? null : json["author_id"],
        publicMetrics: json["public_metrics"] == null
            ? null
            : DatumPublicMetrics.fromJson(json["public_metrics"]),
        attachments: json["attachments"] == null
            ? null
            : Attachments.fromJson(json["attachments"]),
      );
}

class Attachments {
  Attachments({
    this.mediaKeys,
  });

  final List<String>? mediaKeys;

  factory Attachments.fromJson(Map<String, dynamic> json) => Attachments(
        mediaKeys: json["media_keys"] == null
            ? null
            : List<String>.from(json["media_keys"].map((x) => x)),
      );
}

class DatumPublicMetrics {
  DatumPublicMetrics({
    this.retweetCount,
    this.replyCount,
    this.likeCount,
    this.quoteCount,
  });

  final int? retweetCount;
  final int? replyCount;
  final int? likeCount;
  final int? quoteCount;

  factory DatumPublicMetrics.fromJson(Map<String, dynamic> json) =>
      DatumPublicMetrics(
        retweetCount:
            json["retweet_count"] == null ? null : json["retweet_count"],
        replyCount: json["reply_count"] == null ? null : json["reply_count"],
        likeCount: json["like_count"] == null ? null : json["like_count"],
        quoteCount: json["quote_count"] == null ? null : json["quote_count"],
      );

  Map<String, dynamic> toJson() => {
        "retweet_count": retweetCount == null ? null : retweetCount,
        "reply_count": replyCount == null ? null : replyCount,
        "like_count": likeCount == null ? null : likeCount,
        "quote_count": quoteCount == null ? null : quoteCount,
      };
}

class Includes {
  Includes({
    this.users,
    this.media,
  });

  final List<User>? users;
  final List<Media>? media;

  factory Includes.fromJson(Map<String, dynamic> json) => Includes(
        users: json["users"] == null
            ? null
            : List<User>.from(json["users"].map((x) => User.fromJson(x))),
        media: json["media"] == null
            ? null
            : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
      );
}

class Media {
  Media({
    this.mediaKey,
    this.type,
    this.url,
  });

  final String? mediaKey;
  final String? type;
  final String? url;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        mediaKey: json["media_key"] == null ? null : json["media_key"],
        type: json["type"] == null ? null : json["type"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "media_key": mediaKey == null ? null : mediaKey,
        "type": type == null ? null : type,
        "url": url == null ? null : url,
      };
}

class User {
  User({
    this.profileImageUrl,
    this.publicMetrics,
    this.name,
    this.username,
    this.createdAt,
    this.id,
  });

  final String? profileImageUrl;
  final UserPublicMetrics? publicMetrics;
  final String? name;
  final String? username;
  final DateTime? createdAt;
  final String? id;

  factory User.fromJson(Map<String, dynamic> json) => User(
        profileImageUrl: json["profile_image_url"] == null
            ? null
            : json["profile_image_url"],
        publicMetrics: json["public_metrics"] == null
            ? null
            : UserPublicMetrics.fromJson(json["public_metrics"]),
        name: json["name"] == null ? null : json["name"],
        username: json["username"] == null ? null : json["username"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"] == null ? null : json["id"],
      );
}

class UserPublicMetrics {
  UserPublicMetrics({
    this.followersCount,
    this.followingCount,
    this.tweetCount,
    this.listedCount,
  });

  final int? followersCount;
  final int? followingCount;
  final int? tweetCount;
  final int? listedCount;

  factory UserPublicMetrics.fromJson(Map<String, dynamic> json) =>
      UserPublicMetrics(
        followersCount:
            json["followers_count"] == null ? null : json["followers_count"],
        followingCount:
            json["following_count"] == null ? null : json["following_count"],
        tweetCount: json["tweet_count"] == null ? null : json["tweet_count"],
        listedCount: json["listed_count"] == null ? null : json["listed_count"],
      );

  Map<String, dynamic> toJson() => {
        "followers_count": followersCount == null ? null : followersCount,
        "following_count": followingCount == null ? null : followingCount,
        "tweet_count": tweetCount == null ? null : tweetCount,
        "listed_count": listedCount == null ? null : listedCount,
      };
}

class Meta {
  Meta({
    this.oldestId,
    this.newestId,
    this.resultCount,
    this.nextToken,
  });

  final String? oldestId;
  final String? newestId;
  final int? resultCount;
  String? nextToken;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        oldestId: json["oldest_id"] == null ? null : json["oldest_id"],
        newestId: json["newest_id"] == null ? null : json["newest_id"],
        resultCount: json["result_count"] == null ? null : json["result_count"],
        nextToken: json["next_token"] == null ? null : json["next_token"],
      );

  Map<String, dynamic> toJson() => {
        "oldest_id": oldestId == null ? null : oldestId,
        "newest_id": newestId == null ? null : newestId,
        "result_count": resultCount == null ? null : resultCount,
        "next_token": nextToken == null ? null : nextToken,
      };
}
