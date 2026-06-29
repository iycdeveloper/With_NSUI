class Blocks {
  final int id;
  final String districtCode;
  final String stateCode;
  final String assemblyCode;
  final String blockCode;
  final String blockName;

  Blocks(
      {required this.id,
      required this.districtCode,
      required this.stateCode,
      required this.assemblyCode,
      required this.blockCode,
      required this.blockName});

  factory Blocks.fromMap(Map<String, dynamic> data) {
    return Blocks(
        id: data['ID'],
        stateCode: data['MASTER_STATE_CODE'],
        districtCode: data["DISTRICT_CODE"],
        assemblyCode: data["ASSEMBLY_CODE"],
        blockCode: data["BLOCK_CODE"],
        blockName: data["BLOCK_NAME"]);
  }
  Map<String, dynamic> toMap() => {
        "ID": id,
        "MASTER_STATE_CODE": stateCode,
        "DISTRICT_CODE": districtCode,
        "ASSEMBLY_CODE": assemblyCode
      };
}
