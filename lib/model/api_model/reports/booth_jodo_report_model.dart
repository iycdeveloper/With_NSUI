class BoothJodoReportModel {
  String stateCode;
  String? districtName;
  String? assemblyName;
  String? total;
  String? verifiedNumbers;
  String? verifiedBooth;
  String? name;
  String? boothCount;
  String? memberCount;

  BoothJodoReportModel(
      {required this.stateCode,
      required this.assemblyName,
      required this.districtName,
      required this.total,
      required this.verifiedBooth,
      required this.verifiedNumbers,
      required this.name,
      required this.boothCount,
      required this.memberCount});

  factory BoothJodoReportModel.fromJson(Map<String, dynamic> json) =>
      BoothJodoReportModel(
          stateCode: json["state_code"] ?? json["state"],
          districtName: json["district_name"],
          assemblyName: json["assembly_name"] ?? json["assembly"],
          total: json["total"] ?? json["total_entries"] ?? json["total_count"],
          verifiedNumbers: json["verified_members"] ?? json["verified_entries"],
          verifiedBooth: json["verified_booth"],
          name: json["name"] ?? json["aggr_name"],
          boothCount: json["booth_count"],
          memberCount: json["aggr_count"] ?? json["member_count"]);
}

//{state_code: MP, district_name: Agar, assembly_name: Agar (SC), total: 52, verified_members: 52, verified_booth: 52}
