import 'dart:convert';

BatchDownloadResponse welcomeFromJson(String str) =>
    BatchDownloadResponse.fromJson(json.decode(str));

String welcomeToJson(BatchDownloadResponse data) => json.encode(data.toJson());

class BatchDownloadResponse {
  BatchDownloadResponse({
    required this.status,
    required this.response,
  });

  String status;
  BatchDownloadRes response;

  factory BatchDownloadResponse.fromJson(Map<String, dynamic> json) =>
      BatchDownloadResponse(
        status: json["status"],
        response: BatchDownloadRes.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class BatchDownloadRes {
  BatchDownloadRes({
    required this.batches,
  });

  List<Batch> batches;

  factory BatchDownloadRes.fromJson(Map<String, dynamic> json) =>
      BatchDownloadRes(
        batches:
            List<Batch>.from(json["BATCHES"].map((x) => Batch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "BATCHES": List<dynamic>.from(batches.map((x) => x.toJson())),
      };
}

class Batch {
  Batch({
    this.aggrId,
    this.batchNo,
    this.createdOn,
    this.paymentStatus,
    this.paymentOn,
    this.stateCode,
    this.districtCode,
    this.amount,
    this.paymentId,
    this.totalAm,
  });

  String? aggrId;
  String? batchNo;
  DateTime? createdOn;
  String? paymentStatus;
  DateTime? paymentOn;
  String? stateCode;
  String? districtCode;
  String? amount;
  String? paymentId;
  String? totalAm;

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
        aggrId: json["AGGR_ID"],
        batchNo: json["BATCH_NO"],
        createdOn: DateTime.parse(json["CREATED_ON"]),
        paymentStatus: json["PAYMENT_STATUS"],
        paymentOn: (json["PAYMENT_ON"] ?? "").toString().isNotEmpty
            ? DateTime.parse(json["PAYMENT_ON"])
            : null,
        stateCode: json["STATE_CODE"],
        districtCode: json["DISTRICT_CODE"],
        amount: json["AMOUNT"],
        paymentId: json["PAYMENT_ID"],
        totalAm: json["TOTAL_AM"],
      );

  Map<String, dynamic> toJson() => {
        "AGGR_ID": aggrId,
        "BATCH_NO": batchNo,
        "CREATED_ON": createdOn!.toIso8601String(),
        "PAYMENT_STATUS": paymentStatus,
        "PAYMENT_ON": paymentOn!.toIso8601String(),
        "STATE_CODE": stateCode,
        "DISTRICT_CODE": districtCode,
        "AMOUNT": amount,
        "PAYMENT_ID": paymentId,
        "TOTAL_AM": totalAm,
      };
}
