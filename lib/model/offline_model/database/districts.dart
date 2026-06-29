class Districts {
  final int id;
  final String districtCode;
  final String name;
  final String stateCode;
  final String isEnabled;

  Districts(
      {required this.id,
      required this.districtCode,
      required this.name,
      required this.stateCode,
      required this.isEnabled});
  factory Districts.fromMap(Map<String, dynamic> data) {
    return Districts(
        id: data['ID'],
        name: data['DISTRICT_NAME'],
        stateCode: data['MASTER_STATE_CODE'],
        isEnabled: data['IS_ENABLED'],
        districtCode: data["DISTRICT_CODE"]);
  }
  Map<String, dynamic> toMap() => {
        "ID": id,
        "DISTRICT_NAME": name,
        "MASTER_STATE_CODE": stateCode,
        "IS_ENABLED": isEnabled,
        "DISTRICT_CODE": districtCode
      };
}
