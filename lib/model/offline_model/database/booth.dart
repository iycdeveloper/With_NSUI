class Booth {
  final int id;
  final String districtCode;
  final String stateCode;
  final String assemblyCode;
  final String blockCode;
  final String boothCode;
  final String boothName;

  Booth(
      {required this.id,
      required this.districtCode,
      required this.stateCode,
      required this.assemblyCode,
      required this.blockCode,
      required this.boothCode,
      required this.boothName});

  factory Booth.fromMap(Map<String, dynamic> data) {
    return Booth(
        id: data['ID'],
        stateCode: data['MASTER_STATE_CODE'],
        districtCode: data["DISTRICT_CODE"],
        assemblyCode: data["ASSEMBLY_CODE"],
        blockCode: data["BLOCK_CODE"],
        boothCode: data["BOOTH_CODE"],
        boothName: data["BOOTH_NAME"]);
  }
  Map<String, dynamic> toMap() => {
        "ID": id,
        "MASTER_STATE_CODE": stateCode,
        "DISTRICT_CODE": districtCode,
        "ASSEMBLY_CODE": assemblyCode
      };
}
