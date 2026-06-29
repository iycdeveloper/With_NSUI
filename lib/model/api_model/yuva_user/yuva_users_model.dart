class YuvaUsersModel {
  YuvaUsersModel(
      {this.areaName,
      required this.firstName,
      required this.lastName,
      required this.mobile,
      this.email,
      required this.verificationStatus,
      required this.volunteerStatus,
      required this.digitalYouth,
      required this.roleName,
      this.assemblyAssigned,
      this.districtAssigned,
      this.assignedBooths});

  String? areaName;
  String firstName;
  String lastName;
  String mobile;
  String? email;
  String? verificationStatus;
  String? volunteerStatus;
  String? digitalYouth;
  String roleName;
  String? assemblyAssigned;
  String? districtAssigned;
  String? assignedBooths;

  factory YuvaUsersModel.fromJson(Map<String, dynamic> json) => YuvaUsersModel(
      areaName: json["area_name"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      mobile: json["mobile"],
      email: json["email"],
      verificationStatus: json["verification_status"],
      volunteerStatus: json["volunteer_status"],
      digitalYouth: json["digital_youth"],
      roleName: json["role_name"],
      assignedBooths: json["booths_assigned"],
      assemblyAssigned: json["assembly_assigned"],
      districtAssigned: json["district_assigned"]);

  Map<String, dynamic> toJson() => {
        "area_name": areaName,
        "first_name": firstName,
        "last_name": lastName,
        "mobile": mobile,
        "email": email,
        "verification_status": verificationStatus,
        "volunteer_status": volunteerStatus,
        "digital_youth": digitalYouth,
        "role_name": roleName,
      };
}
