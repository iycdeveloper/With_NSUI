import 'dart:convert';

import 'package:iyc/model/data_model/batch_member.dart';

MembershipDownloadResponse membershipDownloadResponseFromJson(String str) =>
    MembershipDownloadResponse.fromJson(json.decode(str));

String membershipDownloadResponseToJson(MembershipDownloadResponse data) =>
    json.encode(data.toJson());

class MembershipDownloadResponse {
  MembershipDownloadResponse({
    required this.status,
    required this.response,
  });

  String status;
  Response response;

  factory MembershipDownloadResponse.fromJson(Map<String, dynamic> json) =>
      MembershipDownloadResponse(
        status: json["status"],
        response: Response.fromJson(json["response"]),
      );

  factory MembershipDownloadResponse.fromJsonforScrutiny(Map<String, dynamic> json) =>
      MembershipDownloadResponse(
        status: json["status"],
        response: Response.fromJsonforScrutiny(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class Response {
  Response({
    this.batchMember,
  });

  List<BatchMember>? batchMember;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        batchMember: List<BatchMember>.from(
            json["BATCH_MEMBER"].map((x) => BatchMember.fromJson(x))),
      );
      factory Response.fromJsonforScrutiny(Map<String, dynamic> json) => Response(
        batchMember: List<BatchMember>.from(
            json["BATCH_MEMBER"].map((x) => BatchMember.fromJsonforScrutiny(x))),
      );

  Map<String, dynamic> toJson() => {
        "BATCH_MEMBER": List<dynamic>.from(batchMember!.map((x) => x.toJson())),
      };
}
