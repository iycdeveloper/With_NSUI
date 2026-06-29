class Mandalam {
  final int id;
  final String districtCode;
  final String stateCode;
  final String assemblyCode;
  final String mandalamCode;
  final String mandalamName;

  Mandalam(
      {required this.id,
      required this.districtCode,
      required this.stateCode,
      required this.assemblyCode,
      required this.mandalamCode,
      required this.mandalamName});

  factory Mandalam.fromMap(Map<String, dynamic> data) {
    return Mandalam(
        id: data['ID'],
        stateCode: data['MASTER_STATE_CODE'],
        districtCode: data["DISTRICT_CODE"],
        assemblyCode: data["ASSEMBLY_CODE"],
        mandalamCode: data["MANDALAM_CODE"],
        mandalamName: data["MANDALAM_NAME"]);
  }
  Map<String, dynamic> toMap() => {
        "ID": id,
        "MASTER_STATE_CODE": stateCode,
        "DISTRICT_CODE": districtCode,
        "ASSEMBLY_CODE": assemblyCode
      };
}
