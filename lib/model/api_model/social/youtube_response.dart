// To parse this JSON data, do
//
//     final youtubeResponse = youtubeResponseFromJson(jsonString);

import 'dart:convert';

YoutubeResponse youtubeResponseFromJson(String str) =>
    YoutubeResponse.fromJson(json.decode(str));

String youtubeResponseToJson(YoutubeResponse data) =>
    json.encode(data.toJson());

class YoutubeResponse {
  YoutubeResponse({
    required this.status,
    required this.response,
  });

  String status;
  List<YoutubeData> response;

  // YoutubeResponse copyWith({
  //   required String status,
  //   required List<YoutubeData> response,
  // }) =>
  //     YoutubeResponse(
  //       status: status ?? this.status,
  //       response: response ?? this.response,
  //     );

  factory YoutubeResponse.fromJson(Map<String, dynamic> json) =>
      YoutubeResponse(
        status: json["status"],
        response: List<YoutubeData>.from(
            json["response"].map((x) => YoutubeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
      };
}

class YoutubeData {
  YoutubeData({
    required this.id,
    required this.channelTitle,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.videoId,
    required this.publishedAt,
    required this.etag,
    required this.createdOn,
  });

  String id;
  String channelTitle;
  String channelId;
  String title;
  String description;
  String thumbnail;
  String videoId;
  DateTime publishedAt;
  String etag;
  DateTime createdOn;

  // YoutubeData copyWith({
  //   String id,
  //   String channelTitle,
  //   String channelId,
  //   String title,
  //   String description,
  //   String thumbnail,
  //   String videoId,
  //   DateTime publishedAt,
  //   String etag,
  //   DateTime createdOn,
  // }) =>
  //     YoutubeData(
  //       id: id ?? this.id,
  //       channelTitle: channelTitle ?? this.channelTitle,
  //       channelId: channelId ?? this.channelId,
  //       title: title ?? this.title,
  //       description: description ?? this.description,
  //       thumbnail: thumbnail ?? this.thumbnail,
  //       videoId: videoId ?? this.videoId,
  //       publishedAt: publishedAt ?? this.publishedAt,
  //       etag: etag ?? this.etag,
  //       createdOn: createdOn ?? this.createdOn,
  //     );

  factory YoutubeData.fromJson(Map<String, dynamic> json) => YoutubeData(
        id: json["id"],
        channelTitle: json["channelTitle"],
        channelId: json["channelId"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"].toString().startsWith(r'"')
            ? json["thumbnail"].toString().replaceFirst(r'"', "")
            : json["thumbnail"],
        videoId: json["videoId"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        etag: json["etag"],
        createdOn: DateTime.parse(json["created_on"]),
      );

  //startsWith(r'\')?json["thumbnail"].toString().trimLeft():
  Map<String, dynamic> toJson() => {
        "id": id,
        "channelTitle": channelTitle,
        "channelId": channelId,
        "title": title,
        "description": description,
        "thumbnail": thumbnail,
        "videoId": videoId,
        "publishedAt": publishedAt.toIso8601String(),
        "etag": etag,
        "created_on": createdOn.toIso8601String(),
      };
}
