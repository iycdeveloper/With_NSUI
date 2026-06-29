class Assembly {
  final int id;
  final String? districtCode;
  final String? districtName;
  final String name;
  final String stateCode;
  final String assemblyCode;
  final String? assemblyNameLocalLang;
  final String isEnabled;
  final String? lokSabhaCode;
  final String? lokSabhaName;
  final String? loksabhaNameLocalLang;

  Assembly(
      {required this.id,
      required this.districtCode,
      required this.name,
      required this.stateCode,
      required this.isEnabled,
      required this.assemblyCode,
      this.assemblyNameLocalLang,
      this.lokSabhaCode,
      this.lokSabhaName,
      this.loksabhaNameLocalLang,
      this.districtName});

  factory Assembly.fromVotersList(Map<String, dynamic> data) {
    return Assembly(
        id: data['ID'],
        name: data['AS_NAME'],
        stateCode: data['STATE_CODE'],
        isEnabled: "true",
        districtName: data["DS_NAME"],
        assemblyCode: data["AS_CODE"].toString(),
        loksabhaNameLocalLang: data["REGIONAL_LS_NAME"],
        assemblyNameLocalLang: data["REGIONAL_AS_NAME"],
        lokSabhaCode: data["LS_CODE"].toString(),
        lokSabhaName: data["LS_NAME"],
        districtCode: data["DS_CODE"].toString());
  }

  factory Assembly.fromMap(Map<String, dynamic> data) {
    return Assembly(
        id: data['ID'],
        name: data['ASSEMBLY_NAME'],
        stateCode: data['MASTER_STATE_CODE'],
        isEnabled: data['IS_ENABLED'],
        districtCode: data["DISTRICT_CODE"],
        assemblyCode: data["ASSEMBLY_CODE"]);
  }

  Map<String, dynamic> toMap() => {
        "ID": id,
        "ASSEMBLY_NAME": name,
        "MASTER_STATE_CODE": stateCode,
        "IS_ENABLED": isEnabled,
        "DISTRICT_CODE": districtCode,
        "ASSEMBLY_CODE": assemblyCode
      };
}
