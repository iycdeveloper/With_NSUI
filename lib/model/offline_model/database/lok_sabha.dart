class LokSabha {
  final int id;
  final String lokSabhaCode;
  final String name;
  final String stateCode;

  LokSabha(
      {required this.id,
        required this.lokSabhaCode,
        required this.name,
        required this.stateCode,});
  factory LokSabha.fromMap(Map<String, dynamic> data) {
    return LokSabha(
        id: data['ID'],
        name: data['DISTRICT_NAME'],
        stateCode: data['MASTER_STATE_CODE'],
        lokSabhaCode: data["DISTRICT_CODE"]);
  }
  Map<String, dynamic> toMap() => {
    "ID": id,
    "DISTRICT_NAME": name,
    "MASTER_STATE_CODE": stateCode,
    "DISTRICT_CODE": lokSabhaCode
  };
}
