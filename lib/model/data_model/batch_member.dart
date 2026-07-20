class BatchMember {
  String? id;
  String? memberId;
  String? batchId;
  String? firstName;
  String? lastName;
  String? relativeName;
  String? relationCode;
  String? gender;
  String? category;
  String? education;
  String? mobile;
  String? pin;
  String? profession;
  String? email;
  String? address;
  String? stateCode;
  String? districtCode;
  String? assemblyCode;
  String? dob;
  String? amPhotoFilePath;
  String? idType;
  String? idValue;
  String? idDocumentFilePath;
  String? stateName;
  String? districtName;
  String? assemblyName;
  String? statePresidentCandidate;
  String? stateGSCandidate;
  String? districtCandidate;
  String? assemblyCandidate;
  String? blockCandidate;
  String? districtGsCandidate;
  String? mandalamCandidate;
  String? boothCandidate;
  String? aggrId;
  String? organizationCode;
  String? city;
  String? blockCode;
  String? boothCode;
  String? referrerId;
  String? declaration;
  String? deviceId;
  String? verificationCode;
  String? channel;
  String? mandalamCode;
  DateTime? createdOn;
  String? createdBy;
  String? expiryDate;
  String? tmpId;
  String? isSync;

  String? scrutinyStatus;
  String? scrutinyCode;
  String? reason;
  String? modifiedOn;
  String? vsn;
  String? votingStatus;
  String? isEditedScrutiny;
  String? videoFilePath;
  String? documentBackPath;
  String? barIdPath;

  bool? isIncMember;
  late bool isLegalCell;
  String? barCouncilId;
  String? adhaarNumber;
  String? adhaarIdFrontPath;
  String? adhaarIdBackPath;

  BatchMember(
      {this.id,
      this.memberId,
      this.batchId,
      this.category,
      this.gender,
      this.lastName,
      this.firstName,
      this.education,
      this.relativeName,
      this.mobile,
      this.pin,
      this.profession,
      this.email,
      this.address,
      this.districtCode,
      this.stateCode,
      this.assemblyCode,
      this.dob,
      this.idType,
      this.amPhotoFilePath,
      this.idDocumentFilePath,
      this.districtName,
      this.assemblyName,
      this.stateName,
      this.assemblyCandidate,
      this.boothCandidate,
      this.districtGsCandidate,
      this.mandalamCandidate,
      this.blockCandidate,
      this.districtCandidate,
      this.stateGSCandidate,
      this.statePresidentCandidate,
      this.aggrId,
      this.organizationCode = "NSUI",
      this.city,
      this.blockCode,
      this.boothCode,
      this.relationCode = "F",
      this.idValue,
      this.referrerId,
      this.declaration,
      this.deviceId,
      this.verificationCode,
      this.channel,
      this.mandalamCode,
      this.createdOn,
      this.createdBy,
      this.expiryDate,
      this.tmpId,
      this.isSync = "0",
      this.scrutinyStatus,
      this.scrutinyCode,
      this.reason,
      this.modifiedOn,
      this.vsn,
      this.votingStatus,
      this.isEditedScrutiny = "0",
      this.videoFilePath,
      this.documentBackPath,
      this.isIncMember = false,
      this.isLegalCell = false,
      this.barIdPath,
      this.barCouncilId,
      this.adhaarNumber,
      this.adhaarIdFrontPath,
      this.adhaarIdBackPath});

  BatchMember copyWith() => BatchMember.fromJson(toJson());

  factory BatchMember.fromJson(Map<String, dynamic> json) => BatchMember(
      id: json["ID"],
      memberId: json["MEMBER_ID"],
      batchId: json["BATCH_NO"],
      assemblyCode: json["ASSEMBLY_CODE"],
      districtCode: json["DISTRICT_CODE"],
      stateCode: json["STATE_CODE"],
      email: json["EMAIL"],
      mobile: json["MOBILE1"],
      pin: json["PINCODE"],
      category: json["CATEGORY_CODE"],
      gender: json["SEX_CODE"],
      education: json["EDUCATION"],
      relativeName: json["RELATIVE_NAME"],
      profession: json["PROFESSION"],
      lastName: json["LAST_NAME"],
      firstName: json["FIRST_NAME"],
      address: json["ADDRESS"],
      amPhotoFilePath: json["AM_PHOTO"],
      dob: json["DATE_OF_BIRTH"],
      idDocumentFilePath: json["ID_DOCUMENT"],
      idType: json["ID_TYPE"],
      assemblyName: json["ASSEMBLY_NAME"],
      districtName: json["DISTRICT_NAME"],
      stateName: json["STATE_NAME"],
      assemblyCandidate: json["CSN_AP"],
      districtCandidate: json["CSN_DP"],
      districtGsCandidate: json["CSN_BT"],
      mandalamCandidate: json["CSN_BL"],
      blockCandidate: json["CSN_BL"],
      boothCandidate: json["CSN_BT"],
      stateGSCandidate: json["CSN_SG"],
      statePresidentCandidate: json["CSN_SP"],
      isSync: json["IS_SYNC"],
      aggrId: json["AGGR_ID"],
      organizationCode: json["ORGANIZATION_CODE"],
      city: json["CITY"],
      blockCode: json["BLOCK_CODE"],
      boothCode: json["BOOTH_CODE"],
      relationCode: json["RELATION_CODE"],
      idValue: json["ID_VALUE"],
      referrerId: json["REFERRER_ID"],
      declaration: json["DECLARATION"],
      verificationCode: json["VERIFICATION_CODE"],
      deviceId: json["DEVICE_ID"],
      channel: json["CHANNEL"],
      mandalamCode: json["MANDALAM_CODE"],
      createdOn: json["CREATED_ON"] != null
          ? DateTime.parse(json["CREATED_ON"])
          : null,
      createdBy: json["CREATED_BY"],
      expiryDate: json["EXPIRY_DATE"],
      tmpId: json["TMP_ID"],
      scrutinyStatus: json["SCRUTINY_STATUS"],
      scrutinyCode: json["SCRUTINY_CODE"],
      reason: json["REASON"],
      modifiedOn: json["MODIFIED_ON"],
      vsn: json["VSN"],
      votingStatus: json["VOTING_STATUS"],
      isEditedScrutiny: json['IS_EDITED_SCRUTINY'],
      videoFilePath: json['VIDEO_FILE_PATH'],
      documentBackPath: json['DOCUMENT_BACK_PATH'],
      adhaarIdBackPath: json["AADHAR_BACK_PATH"],
      adhaarIdFrontPath: json['AADHAR_FRONT_PATH'],
      adhaarNumber: json['AADHAR'],
      isIncMember:
          (json["TMP_ID"]?.toString() ?? "").startsWith("INC") ? true : false);

  factory BatchMember.fromJsonforScrutiny(Map<String, dynamic> json) =>
      BatchMember(
          id: json["ID"],
          memberId: json["MEMBER_ID"],
          batchId: json["BATCH_NO"],
          assemblyCode: json["ASSEMBLY_CODE"],
          districtCode: json["DISTRICT_CODE"],
          stateCode: json["STATE_CODE"],
          email: json["EMAIL"],
          mobile: json["MOBILE1"],
          pin: json["PINCODE"],
          category: json["CATEGORY_CODE"],
          gender: json["SEX_CODE"],
          education: json["EDUCATION"],
          relativeName: json["RELATIVE_NAME"],
          profession: json["PROFESSION"],
          lastName: json["LAST_NAME"],
          firstName: json["FIRST_NAME"],
          address: json["ADDRESS"],
          amPhotoFilePath: json["PHOTO_LINK"], //
          dob: json["DATE_OF_BIRTH"],
          idDocumentFilePath: json["ID_FRONT"], //
          idType: json["ID_TYPE"],
          assemblyName: json["ASSEMBLY_NAME"],
          districtName: json["DISTRICT_NAME"],
          stateName: json["STATE_NAME"],
          assemblyCandidate: json["CSN_AP"],
          districtCandidate: json["CSN_DP"],
          districtGsCandidate: json["CSN_BT"],
          mandalamCandidate: json["CSN_BL"],
          blockCandidate: json["CSN_BL"],
          boothCandidate: json["CSN_BT"],
          stateGSCandidate: json["CSN_SG"],
          statePresidentCandidate: json["CSN_SP"],
          isSync: json["IS_SYNC"],
          aggrId: json["AGGR_ID"],
          organizationCode: json["ORGANIZATION_CODE"],
          city: json["CITY"],
          blockCode: json["BLOCK_CODE"],
          boothCode: json["BOOTH_CODE"],
          relationCode: json["RELATION_CODE"],
          idValue: json["ID_VALUE"],
          referrerId: json["REFERRER_ID"],
          declaration: json["DECLARATION"],
          verificationCode: json["VERIFICATION_CODE"],
          deviceId: json["DEVICE_ID"],
          channel: json["CHANNEL"],
          mandalamCode: json["MANDALAM_CODE"],
          createdOn: json["CREATED_ON"] != null
              ? DateTime.parse(json["CREATED_ON"])
              : null,
          createdBy: json["CREATED_BY"],
          expiryDate: json["EXPIRY_DATE"],
          tmpId: json["TMP_ID"],
          scrutinyStatus: json["SCRUTINY_STATUS"],
          scrutinyCode: json["SCRUTINY_CODE"],
          reason: json["REASON"],
          modifiedOn: json["MODIFIED_ON"],
          vsn: json["VSN"],
          votingStatus: json["VOTING_STATUS"],
          isEditedScrutiny: json['IS_EDITED_SCRUTINY'],
          videoFilePath: json['VIDEO'], //
          documentBackPath: json['ID_BACK'], //
          adhaarIdBackPath: json["AADHAR_BACK_PATH"],
          adhaarIdFrontPath: json['AADHAR_FRONT_PATH'],
          adhaarNumber: json['AADHAR'],
          isIncMember: (json["TMP_ID"]?.toString() ?? "").startsWith("INC")
              ? true
              : false);

  factory BatchMember.fromINCJson(Map<String, dynamic> json) => BatchMember(
      firstName: json["first_name"],
      lastName: json["last_name"],
      mobile: json["mobile"],
      gender: json["sex_code"],
      category: json["category_code"],
      dob: json["date_of_birth"],
      stateCode: json["state_code"],
      districtCode: json["district_code"],
      assemblyCode: json["assembly_code"],
      tmpId: json["tmp_id"],
      isIncMember: true);

  /// for rest api
  Map<String, Object?> toJson() => {
        "MEMBER_ID": memberId,
        "BATCH_NO": batchId,
        "CATEGORY_CODE": category,
        "SEX_CODE": gender,
        "LAST_NAME": lastName,
        "FIRST_NAME": firstName,
        "EDUCATION": education ?? "",
        "RELATIVE_NAME": relativeName ?? "",
        "MOBILE1": mobile,
        "VERIFICATION_CODE": verificationCode ?? "",
        "PINCODE": pin ?? "",
        "PROFESSION": profession ?? "",
        "EMAIL": email ?? "",
        "ADDRESS": address ?? "",
        "STATE_CODE": stateCode,
        "DISTRICT_CODE": districtCode,
        "ASSEMBLY_CODE": assemblyCode ?? "",
        "DATE_OF_BIRTH": dob,
        "ID_TYPE": idType ?? "",
        "ID_VALUE": idValue ?? "",
        "CSN_SP": statePresidentCandidate,
        "CSN_SG": stateGSCandidate,
        "CSN_DP": districtCandidate,
        "CSN_AP": assemblyCandidate,
        "CSN_BL": mandalamCandidate ?? blockCandidate ?? "",
        "CSN_BT": districtGsCandidate ?? boothCandidate ?? "",
        "AGGR_ID": aggrId,
        "CHANNEL": "M",
        if (scrutinyCode != null) "SCRUTINY_CODE": scrutinyCode,
        "RELATION_CODE": "F",
        "CREATED_BY": createdBy ?? "",
        "TMP_ID": tmpId!.isNotEmpty
            ? tmpId
            : DateTime.now().millisecondsSinceEpoch.toString(),
        "DEVICE_ID": deviceId ?? "",
        "REFERRER_ID": referrerId ?? "",
        "BOOTH_CODE": boothCode ?? "",
        "CITY": education ?? "",
        "MANDALAM_CODE": mandalamCode ?? "",
        "BLOCK_CODE": blockCode ?? "",
        "ORGANIZATION_CODE": "NSUI",
        "AADHAR": adhaarNumber ?? ''
      };

  /// to dave db
  Map<String, Object?> toMap() => {
        if (id != null) "ID": id, //
        if (memberId != null) "MEMBER_ID": memberId, //
        if (batchId != null) "BATCH_NO": batchId, //
        if (category != null) "CATEGORY_CODE": category, //
        if (gender != null) "SEX_CODE": gender, //
        if (lastName != null) "LAST_NAME": lastName, //
        if (firstName != null) "FIRST_NAME": firstName, //
        if (education != null) "EDUCATION": education, //
        if (relativeName != null) "RELATIVE_NAME": relativeName, //
        "RELATION_CODE": "F",
        if (mobile != null) "MOBILE1": mobile,
        if (verificationCode != null) "VERIFICATION_CODE": verificationCode, //
        if (pin != null) "PINCODE": pin, //
        if (profession != null) "PROFESSION": profession,
        if (email != null) "EMAIL": email,
        if (address != null) "ADDRESS": address,
        if (stateCode != null) "STATE_CODE": stateCode,
        if (districtCode != null) "DISTRICT_CODE": districtCode,
        if (assemblyCode != null) "ASSEMBLY_CODE": assemblyCode,
        if (dob != null) "DATE_OF_BIRTH": dob,
        if (idType != null) "ID_TYPE": idType,
        if (idValue != null) "ID_VALUE": idValue,
        if (idDocumentFilePath != null) "ID_DOCUMENT": idDocumentFilePath,
        if (amPhotoFilePath != null) "AM_PHOTO": amPhotoFilePath,
        if (districtName != null) "DISTRICT_NAME": districtName,
        if (stateName != null) "STATE_NAME": stateName,
        if (assemblyName != null) "ASSEMBLY_NAME": assemblyName,
        if (statePresidentCandidate != null) "CSN_SP": statePresidentCandidate,
        if (stateGSCandidate != null) "CSN_SG": stateGSCandidate,
        if (districtCandidate != null) "CSN_DP": districtCandidate,
        if (assemblyCandidate != null) "CSN_AP": assemblyCandidate,
        if (blockCandidate != null) "CSN_BL": blockCandidate,
        if (mandalamCandidate != null) "CSN_BL": mandalamCandidate,
        if (boothCandidate != null) "CSN_BT": boothCandidate,
        if (districtGsCandidate != null) "CSN_BT": districtGsCandidate,
        if (isSync != null) "IS_SYNC": isSync,
        if (scrutinyStatus != null) "SCRUTINY_STATUS": scrutinyStatus,
        if (scrutinyCode != null) "SCRUTINY_CODE": scrutinyCode,
        if (reason != null) "REASON": reason, ////
        if (vsn != null) "VSN": vsn, ////
        if (votingStatus != null) "VOTING_STATUS": votingStatus, ////
        if (modifiedOn != null) "MODIFIED_ON": modifiedOn,
        if (isEditedScrutiny != null) "IS_EDITED_SCRUTINY": isEditedScrutiny,
        if (videoFilePath != null) "VIDEO_FILE_PATH": videoFilePath,
        if (documentBackPath != null) "DOCUMENT_BACK_PATH": documentBackPath,
        "CREATED_BY": createdBy ?? "",
        "AGGR_ID": aggrId ?? "",
        "TMP_ID": tmpId ?? "",
        "DEVICE_ID": deviceId ?? "",
        if (verificationCode != null) "VERIFICATION_CODE": verificationCode,
        "REFERRER_ID": referrerId ?? "",
        "BOOTH_CODE": boothCode ?? "",
        "CITY": city ?? "",
        "MANDALAM_CODE": mandalamCode ?? "",
        "BLOCK_CODE": blockCode ?? "",
        "CHANNEL": "M",
        "IS_INC_MEMBER": "$isIncMember"
      };
  //to dave db for membership_batch_members
  Map<String, Object?> toMap2() => {
        if (id != null) "ID": id, //
        if (memberId != null) "MEMBER_ID": memberId, //
        if (batchId != null) "BATCH_NO": batchId, //
        if (category != null) "CATEGORY_CODE": category, //
        if (gender != null) "SEX_CODE": gender, //
        if (lastName != null) "LAST_NAME": lastName, //
        if (firstName != null) "FIRST_NAME": firstName, //
        if (education != null) "EDUCATION": education, //
        if (relativeName != null) "RELATIVE_NAME": relativeName, //
        "RELATION_CODE": "F",
        if (mobile != null) "MOBILE1": mobile,
        if (verificationCode != null) "VERIFICATION_CODE": verificationCode, //
        if (pin != null) "PINCODE": pin, //
        if (profession != null) "PROFESSION": profession,
        if (email != null) "EMAIL": email,
        if (address != null) "ADDRESS": address,
        if (stateCode != null) "STATE_CODE": stateCode,
        if (districtCode != null) "DISTRICT_CODE": districtCode,
        if (assemblyCode != null) "ASSEMBLY_CODE": assemblyCode,
        if (dob != null) "DATE_OF_BIRTH": dob,
        if (idType != null) "ID_TYPE": idType,
        if (idValue != null) "ID_VALUE": idValue,
        if (idDocumentFilePath != null) "ID_DOCUMENT": idDocumentFilePath,
        if (amPhotoFilePath != null) "AM_PHOTO": amPhotoFilePath,
        if (districtName != null) "DISTRICT_NAME": districtName,
        if (stateName != null) "STATE_NAME": stateName,
        if (assemblyName != null) "ASSEMBLY_NAME": assemblyName,
        if (statePresidentCandidate != null) "CSN_SP": statePresidentCandidate,
        if (stateGSCandidate != null) "CSN_SG": stateGSCandidate,
        if (districtCandidate != null) "CSN_DP": districtCandidate,
        if (assemblyCandidate != null) "CSN_AP": assemblyCandidate,
        if (blockCandidate != null) "CSN_BL": blockCandidate,
        if (mandalamCandidate != null) "CSN_BL": mandalamCandidate,
        if (boothCandidate != null) "CSN_BT": boothCandidate,
        if (districtGsCandidate != null) "CSN_BT": districtGsCandidate,
        if (isSync != null) "IS_SYNC": isSync,
        if (scrutinyStatus != null) "SCRUTINY_STATUS": scrutinyStatus,
        if (scrutinyCode != null) "SCRUTINY_CODE": scrutinyCode,
        if (reason != null) "REASON": reason, ////
        if (vsn != null) "VSN": vsn, ////
        if (votingStatus != null) "VOTING_STATUS": votingStatus, ////
        if (modifiedOn != null) "MODIFIED_ON": modifiedOn,
        if (isEditedScrutiny != null) "IS_EDITED_SCRUTINY": isEditedScrutiny,
        if (videoFilePath != null) "VIDEO_FILE_PATH": videoFilePath,
        if (documentBackPath != null) "DOCUMENT_BACK_PATH": documentBackPath,
        //
        if (adhaarIdBackPath != null) "AADHAR_BACK_PATH": adhaarIdBackPath,
        if (adhaarIdFrontPath != null) "AADHAR_FRONT_PATH": adhaarIdFrontPath,
        if (adhaarNumber != null) "AADHAR": adhaarNumber,
        "CREATED_BY": createdBy ?? "",
        "AGGR_ID": aggrId ?? "",
        "TMP_ID": tmpId ?? "",
        "DEVICE_ID": deviceId ?? "",
        if (verificationCode != null) "VERIFICATION_CODE": verificationCode,
        "REFERRER_ID": referrerId ?? "",
        "BOOTH_CODE": boothCode ?? "",
        "CITY": city ?? "",
        "MANDALAM_CODE": mandalamCode ?? "",
        "BLOCK_CODE": blockCode ?? "",
        "CHANNEL": "M",
        "IS_INC_MEMBER": "$isIncMember"
      };
  BatchMember.fromMap(Map<dynamic, dynamic> mapData) {
    print("from map batchn member : $mapData");
    this.id = mapData['ID'];
    this.memberId = mapData['MEMBER_ID'];
    this.batchId = mapData['BATCH_NO'];
    this.category = mapData['CATEGORY_CODE'];
    this.gender = mapData['SEX_CODE'];
    this.lastName = mapData['LAST_NAME'];
    this.firstName = mapData['FIRST_NAME'];
    this.education = mapData['EDUCATION'];
    this.relativeName = mapData['RELATIVE_NAME'];
    this.relationCode = mapData['RELATION_CODE'];
    this.mobile = mapData['MOBILE1'];
    this.pin = mapData['PINCODE'];
    this.aggrId = mapData["AGGR_ID"];
    this.profession = mapData['PROFESSION'];
    this.email = mapData['EMAIL'];
    this.address = mapData['ADDRESS'];
    this.stateCode = mapData['STATE_CODE'];
    this.districtCode = mapData['DISTRICT_CODE'];
    this.assemblyCode = mapData['ASSEMBLY_CODE'];
    this.idType = mapData['ID_TYPE'];
    this.idValue = mapData['ID_VALUE'];
    this.dob = mapData['DATE_OF_BIRTH'];
    this.assemblyName = mapData['ASSEMBLY_NAME'];
    this.districtName = mapData['DISTRICT_NAME'];
    this.blockCode = mapData['BLOCK_CODE'];
    this.boothCode = mapData['BOOTH_CODE'];
    this.stateName = mapData['STATE_NAME'];
    this.stateGSCandidate = mapData['CSN_SG'];
    this.districtCandidate = mapData['CSN_DP'];
    this.assemblyCandidate = mapData['CSN_AP'];
    this.districtGsCandidate = mapData["CSN_BT"];
    this.mandalamCandidate = mapData["CSN_BL"];
    this.blockCandidate = mapData['CSN_BL'];
    this.boothCandidate = mapData['CSN_BT'];
    this.statePresidentCandidate = mapData['CSN_SP'];
    this.scrutinyCode = mapData["SCRUTINY_CODE"];
    this.verificationCode = mapData["verification_code"];
    this.isSync = mapData['IS_SYNC'];
    this.isEditedScrutiny = mapData['IS_EDITED_SCRUTINY'];
    this.amPhotoFilePath = mapData['AM_PHOTO'];
    this.videoFilePath = mapData['VIDEO_FILE_PATH'];
    this.idDocumentFilePath = mapData['ID_DOCUMENT'];
    this.documentBackPath = mapData['DOCUMENT_BACK_PATH'];
    this.verificationCode = mapData['VERIFICATION_CODE'];
    this.tmpId = mapData["TMP_ID"];
    this.isIncMember =
        (mapData["TMP_ID"]?.toString() ?? "").startsWith("INC") ? true : false;
    this.isLegalCell = false;
  }
}
