// To parse this JSON data, do
//
//     final reportsResponse = reportsResponseFromJson(jsonString);

import 'dart:convert';


ReportsResponse reportsResponseFromJson(String str) => ReportsResponse.fromJson(json.decode(str));

String welcomeToJson(ReportsResponse data) => json.encode(data.toJson());

class ReportsResponse {
  ReportsResponse({
    required this.status,
    required this.response,
  });

  String status;
  List<Report> response;

  factory ReportsResponse.fromJson(Map<String, dynamic> json) => ReportsResponse(
    status: json["status"],
    response: List<Report>.from(json["response"].map((x) => Report.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": List<dynamic>.from(response.map((x) => x.toJson())),
  };
}
class Report {
  Report({
    this.id,
    this.reportId,
    this.reportName,
    this.module,
    this.accessLevel,
    this.reportLink,
  });

  String? id;
  String? reportId;
  String? reportName;
  String? module;
  String? accessLevel;
  String? reportLink;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    id: json["id"],
    reportId: json["report_id"],
    reportName: json["report_name"],
    module: json["module"],
    accessLevel: json["access_level"],
    reportLink: json["report_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "report_id": reportId,
    "report_name": reportName,
    "module": module,
    "access_level": accessLevel,
    "report_link": reportLink,
  };
}
