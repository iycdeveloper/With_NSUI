class BoothJodo {
  BoothJodo({
    required this.name,
    required this.mobile,
    required this.stateCode,
    required this.verificationStatus,
  });

  String name;
  String mobile;
  String stateCode;
  String verificationStatus;

  factory BoothJodo.fromJson(Map<String, dynamic> json) => BoothJodo(
        name: json["name"],
        mobile: json["mobile"],
        stateCode: json["state_code"],
        verificationStatus: json["verification_status"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile": mobile,
        "state_code": stateCode,
        "verification_status": verificationStatus,
      };
}
