class LoginModel {
  String? name;
  String mobile;
  String? email;
  String? stateCode;
  String? districtCode;

  LoginModel(
      {this.name,
      required this.mobile,
      this.email,
      this.stateCode,
      this.districtCode});
}
