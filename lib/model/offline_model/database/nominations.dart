class Nomination {
  final int id;
  final int? districtCode;
  final String? name;
  final String? stateCode;
  final int? assemblyCode;
  final int? blockCode;
  final int? boothCode;
  final int? csn;
  final String? contestingFor;
  final String? memberID;
  final String? firstName;
  final String? lastName;
  final int? masterLevelId;

  Nomination(
      {required this.id,
      this.districtCode,
      this.name,
      this.stateCode,
      this.assemblyCode,
      this.lastName,
      this.firstName,
      this.blockCode,
      this.boothCode,
      this.contestingFor,
      this.csn,
      this.masterLevelId,
      this.memberID});

  factory Nomination.fromMap(Map<String, dynamic> data) {
    return Nomination(
      id: data['ID'],
      name: data['ASSEMBLY_NAME'],
      stateCode: data['STATE_CODE'],
      districtCode: data["DISTRICT_CODE"],
      assemblyCode:
          (data["ASSEMBLY_CODE"] is int) ? data["ASSEMBLY_CODE"] : null,
      lastName: data["LAST_NAME"],
      blockCode: (data["BLOCK_CODE"] is int) ? data["BLOCK_CODE"] : null,
      boothCode: data["BOOTH_CODE"],
      contestingFor: data["CONTESTING_FOR"],
      csn: data["CSN"],
      firstName: data["FIRST_NAME"],
      masterLevelId: data["MASTER_LEVEL_ID_"],
      memberID: data["MEMBER_ID"],
    );
  }

  Map<String, dynamic> toMap() => {
        "ID": id,
        "ASSEMBLY_NAME": name,
        "MASTER_STATE_CODE": stateCode,
        "DISTRICT_CODE": districtCode,
        "ASSEMBLY_CODE": assemblyCode,
        "BLOCK_CODE": blockCode,
        "CSN": csn,
        "CONTESTING_FOR": contestingFor,
        "MEMBER_ID": memberID,
        "FIRST_NAME": firstName,
        "LAST_NAME": lastName,
        "MASTER_LEVEL_ID_": masterLevelId
      };
}
