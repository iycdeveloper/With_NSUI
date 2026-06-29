class ObUser {
  ObUser(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.mobile,
      required this.stateCode,
      required this.assemblyCode,
      required this.districtCode,
      this.blockCode,
      this.boothCode,
      required this.postAlloted,
      this.isSelected = false});

  String id;
  String firstName;
  String lastName;
  String? mobile;
  String stateCode;
  String assemblyCode;
  String districtCode;
  String? blockCode;
  String? boothCode;
  String postAlloted;
  bool isSelected;

  factory ObUser.fromJson(Map<String, dynamic> json) => ObUser(
        id: json["ID"].toString(),
        firstName: json["FIRST_NAME"],
        lastName: json["LAST_NAME"],
        mobile: json["MOBILE"],
        stateCode: json["STATE_CODE"] ?? json["STATE"],
        assemblyCode: json["ASSEMBLY_CODE"],
        districtCode: json["DISTRICT_CODE"],
        blockCode: json["BLOCK_CODE"],
        boothCode: json["BOOTH_CODE"],
        postAlloted: json["POST_ALLOTED"],
      );

  Map<String, dynamic> toJson() => {
        "FIRST_NAME": firstName,
        "LAST_NAME": lastName,
        "MOBILE": mobile,
        "STATE_CODE": stateCode,
        "ASSEMBLY_CODE": assemblyCode,
        "DISTRICT_CODE": districtCode,
        "BLOCK_CODE": blockCode,
        "BOOTH_CODE": boothCode,
        "POST_ALLOTED": postAlloted,
      };
}
