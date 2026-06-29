class RegisterModel {
  String name;
  String mobile;
  String email;
  String stateCode;
  String? districtCode;
  String? assemblyCode;
  String? blockCode;
  String? genderCode;
  String? dob;
  String? twitterId;
  String? fbId;
  String? instagramId;
  String amImagePath;
  String? amEpicIdPath;
  String? epicId;
  String? caste;
  String? subCaste;
  RegisterModel({
    required this.name,
    required this.mobile,
    required this.email,
    required this.stateCode,
    this.districtCode,
    this.assemblyCode,
    this.blockCode,
    this.genderCode,
    this.dob,
    this.fbId,
    this.instagramId,
    this.twitterId,
    required this.amImagePath,
    this.amEpicIdPath,
    this.epicId,
    this.caste,
    this.subCaste
  });
}
