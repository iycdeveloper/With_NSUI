import 'dart:convert';

DobRangeModel dobRangeModelFromJson(String str) =>
    DobRangeModel.fromJson(json.decode(str));

String dobRangeModelToJson(DobRangeModel data) => json.encode(data.toJson());

class DobRangeModel {
  DobRangeModel({
    required this.status,
    required this.response,
  });

  String status;
  DobRangeModelResponse response;

  factory DobRangeModel.fromJson(Map<String, dynamic> json) => DobRangeModel(
        status: json["status"],
        response: DobRangeModelResponse.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response": response.toJson(),
      };
}

class DobRangeModelResponse {
  DobRangeModelResponse(
      {this.dobstartrange,
      this.dobendrange,
      this.accessCode,
      this.merchantId,
      this.s3Code,
      this.s3Secret,
      required this.s3Bucket});

  String? dobstartrange;
  String? dobendrange;
  String? accessCode;
  String? merchantId;
  String? s3Code;
  String? s3Secret;
  String s3Bucket;

  factory DobRangeModelResponse.fromJson(Map<String, dynamic> json) =>
      DobRangeModelResponse(
          dobstartrange: json["DOBSTARTRANGE"],
          dobendrange: json["DOBENDRANGE"],
          accessCode: json["ACCESS-CODE"],
          merchantId: json["MERCHANT-ID"],
          s3Code: json["S3-CODE"],
          s3Secret: json["S3-SECRET"],
          s3Bucket: json["S3-BUCKET"]);

  Map<String, dynamic> toJson() => {
        "DOBSTARTRANGE": dobstartrange,
        "DOBENDRANGE": dobendrange,
        "ACCESS-CODE": accessCode,
        "MERCHANT-ID": merchantId,
        "S3-CODE": s3Code,
        "S3-SECRET": s3Secret,
      };
}
