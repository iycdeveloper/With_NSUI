// To parse this JSON data, do
//
//     final facebookResponse = facebookResponseFromJson(jsonString);

import 'dart:convert';

FacebookResponse facebookResponseFromJson(String str) =>
    FacebookResponse.fromJson(json.decode(str));

String facebookResponseToJson(FacebookResponse data) =>
    json.encode(data.toJson());

class FacebookResponse {
  FacebookResponse({
    this.data,
    this.paging,
  });

  List<FacebookData>? data;
  Paging? paging;

  FacebookResponse copyWith({
    List<FacebookData>? data,
    Paging? paging,
  }) =>
      FacebookResponse(
        data: data ?? this.data,
        paging: paging ?? this.paging,
      );

  factory FacebookResponse.fromJson(Map<String, dynamic> json) =>
      FacebookResponse(
        data: List<FacebookData>.from(
            json["data"].map((x) => FacebookData.fromJson(x))),
        paging: Paging.fromJson(json["paging"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "paging": paging!.toJson(),
      };
}

class FacebookData {
  FacebookData({
    required this.fullPicture,
    required this.id,
    required this.createdTime,
    required this.message,
    required this.attachments
  });

  String fullPicture;
  String id;
  String createdTime;
  String message;
  Attachments attachments;
  // FacebookData copyWith({
  //   required String fullPicture,
  //   required String id,
  //   required String createdTime,
  //   required String message,
  // }) =>
  //     FacebookData(
  //       fullPicture: fullPicture ?? this.fullPicture,
  //       id: id ?? this.id,
  //       createdTime: createdTime ?? this.createdTime,
  //       message: message ?? this.message,
  //     );

  factory FacebookData.fromJson(Map<String, dynamic> json) => FacebookData(
        fullPicture: json["full_picture"],
        id: json["id"],
        createdTime: json["created_time"],
        message: json["message"] ?? "",
  attachments: Attachments.fromJson(json["attachments"]),
      );

  Map<String, dynamic> toJson() => {
        "full_picture": fullPicture,
        "id": id,
        "created_time": createdTime,
        "message": message,
    "attachments": attachments.toJson(),
      };
}

class Paging {
  Paging({
    required this.cursors,
  });

  Cursors cursors;

  // Paging copyWith({
  //   required Cursors cursors,
  // }) =>
  //     Paging(
  //       cursors: cursors ?? this.cursors,
  //     );

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        cursors: Cursors.fromJson(json["cursors"]),
      );

  Map<String, dynamic> toJson() => {
        "cursors": cursors.toJson(),
      };
}

class Cursors {
  Cursors({
    required this.before,
    required this.after,
  });

  String before;
  String after;

  // Cursors copyWith({
  //   required String before,
  //   required String after,
  // }) =>
  //     Cursors(
  //       before: before ?? this.before,
  //       after: after ?? this.after,
  //     );

  factory Cursors.fromJson(Map<String, dynamic> json) => Cursors(
        before: json["before"],
        after: json["after"],
      );

  Map<String, dynamic> toJson() => {
        "before": before,
        "after": after,
      };
}
class Attachments {
  Attachments({
    this.data,
  });

  List<AttachmentsDatum>? data;

  factory Attachments.fromJson(Map<String, dynamic> json) => Attachments(
    data: List<AttachmentsDatum>.from(json["data"].map((x) => AttachmentsDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
class AttachmentsDatum {
  AttachmentsDatum({
    this.media,
    this.target,
    this.title,
    this.type,
    this.url,
  });

  Media? media;
  Target? target;
  String? title;
  String? type;
  String? url;

  factory AttachmentsDatum.fromJson(Map<String, dynamic> json) => AttachmentsDatum(
    media: Media.fromJson(json["media"]),
    target: Target.fromJson(json["target"]),
    title: json["title"],
    type: json["type"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "media": media!.toJson(),
    "target": target!.toJson(),
    "title": title,
    "type": type,
    "url": url,
  };
}

class Media {
  Media({
    this.image,
    this.source,
  });

  Image? image;
  String? source;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    image: Image.fromJson(json["image"]),
    source: json["source"],
  );

  Map<String, dynamic> toJson() => {
    "image": image!.toJson(),
    "source": source,
  };
}

class Image {
  Image({
    this.height,
    this.src,
    this.width,
  });

  int? height;
  String? src;
  int? width;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    height: json["height"],
    src: json["src"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "src": src,
    "width": width,
  };
}

class Target {
  Target({
    this.id,
    this.url,
  });

  String? id;
  String? url;

  factory Target.fromJson(Map<String, dynamic> json) => Target(
    id: json["id"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
  };
}
