import 'dart:convert';

import 'package:iyc/model/api_model/batch/batch_data_model.dart';

ScrutinyBatchDownloadResponse scrutinyBatchDownloadResponseResponseFromJson(
        String str) =>
    ScrutinyBatchDownloadResponse.fromJson(json.decode(str));

String scrutinyBatchDownloadResponseResponseToJson(
        ScrutinyBatchDownloadResponse data) =>
    json.encode(data.toJson());

class ScrutinyBatchDownloadResponse {
  ScrutinyBatchDownloadResponse({
    required this.status,
    required this.response,
  });

  String status;
  ScrutinyBatchDownloadResponseResponse response;

  factory ScrutinyBatchDownloadResponse.fromJson(Map<String, dynamic> json) =>
      ScrutinyBatchDownloadResponse(
        status: json["status"],
        response:
            ScrutinyBatchDownloadResponseResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class ScrutinyBatchDownloadResponseResponse {
  ScrutinyBatchDownloadResponseResponse({
    required this.batches,
  });

  List<BatchDataModel> batches;

  factory ScrutinyBatchDownloadResponseResponse.fromJson(
          Map<String, dynamic> json) =>
      ScrutinyBatchDownloadResponseResponse(
        batches: List<BatchDataModel>.from(
            json["BATCHES"].map((x) => BatchDataModel.fromScrutinyMap(x))),
      );

  Map<String, dynamic> toJson() => {
        "BATCHES": List<dynamic>.from(batches.map((x) => x.toJson())),
      };
}

class ScrutinyBatch {
  ScrutinyBatch({
    this.batchNo,
    this.totalam,
    this.onhold,
  });

  String? batchNo;
  String? totalam;
  String? onhold;

  factory ScrutinyBatch.fromJson(Map<String, dynamic> json) => ScrutinyBatch(
        batchNo: json["BATCH_NO"],
        totalam: json["TOTALAM"],
        onhold: json["ONHOLD"],
      );

  Map<String, dynamic> toJson() => {
        "BATCH_NO": batchNo,
        "TOTALAM": totalam,
        "ONHOLD": onhold,
      };
}
