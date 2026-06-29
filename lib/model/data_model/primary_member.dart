// To parse this JSON data, do
//
//     final incMember = incMemberFromJson(jsonString);

import 'package:iyc/model/data_model/batch_member.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class PrimaryMember {
  PrimaryMember(
      {this.firstName,
      this.lastName,
      this.mobile,
      this.idCardNumber,
      this.categoryCode,
      this.dateOfBirth,
      this.stateCode,
      this.districtCode,
      this.assemblyCode,
      this.tmpId,
      this.activeStatus,
      this.aggrId,
      this.batchNumber,
      this.memberId,
      this.boothCode,
      this.refererId = "",

      /// refere id will bbe empty fo
      this.createdBy = "",
      this.createdOn = "",
      this.declaration = "1",
      this.idType = ""});

  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? idCardNumber;
  final String? batchNumber;
  final String? aggrId;
  final String? memberId;
  final String? activeStatus;
  late final String? refererId;
  final String? createdBy;
  final String? createdOn;
  final String? categoryCode;
  final String? dateOfBirth;
  final String? stateCode;
  final String? districtCode;
  final String? assemblyCode;
  final String? boothCode;
  final String? tmpId;
  final String? declaration;
  final String? idType;

  // PrimaryMember copyWith({
  //   String? firstName,
  //   String? lastName,
  //   String? mobile,
  //   String? sexCode,
  //   String? categoryCode,
  //   String? dateOfBirth,
  //   String? stateCode,
  //   String? districtCode,
  //   String? assemblyCode,
  //   String? tmpId,
  //   String? idCardNumber,
  //   String? refererId,
  //   String? memberId,
  //   String? batchNumber,
  // }) =>
  //     PrimaryMember(
  //       firstName: firstName ?? this.firstName,
  //       lastName: lastName ?? this.lastName,
  //       mobile: mobile ?? this.mobile,
  //       idCardNumber: idCardNumber ?? this.idCardNumber,
  //       categoryCode: categoryCode ?? this.categoryCode,
  //       dateOfBirth: dateOfBirth ?? this.dateOfBirth,
  //       stateCode: stateCode ?? this.stateCode,
  //       districtCode: districtCode ?? this.districtCode,
  //       assemblyCode: assemblyCode ?? this.assemblyCode,
  //       tmpId: tmpId ?? this.tmpId,
  //       memberId: memberId ?? this.memberId,
  //       refererId: refererId ?? this.refererId,
  //       batchNumber: batchNumber
  //     );
  // factory PrimaryMember.fromBatchMember(BatchMember batchMember) =>
  //     PrimaryMember(
  //       aggrId: batchMember.aggrId,
  //       assemblyCode: batchMember.assemblyCode,
  //       districtCode: batchMember.districtCode,
  //       stateCode: batchMember.stateCode,
  //       boothCode: batchMember.boothCode,
  //       batchNumber: batchMember.batchId,
  //       refererId: batchMember.memberId
  //     );

  factory PrimaryMember.fromRawJson(String str) =>
      PrimaryMember.fromJson(json.decode(str));

  // String toRawJson() => json.encode(toJson());

  factory PrimaryMember.fromJson(Map<String, dynamic> json) => PrimaryMember(
      firstName: json["FIRST_NAME"],
      lastName: json["LAST_NAME"],
      mobile: json["MOBILE"],
      idCardNumber: json["ID"],
      dateOfBirth: json["DOB"],
      stateCode: json["STATE_CODE"],
      districtCode: json["DISTRICT_CODE"],
      assemblyCode: json["ASSEMBLY_CODE"],
      batchNumber: json["BATCH_NO"],
      memberId: json["MEMBER_ID"],
      tmpId: json["TMP_ID"],
      refererId: json["REFERRER_ID"],
      createdBy: json["CREATED_BY"],
      createdOn: json["CREATED_ON"],
      declaration: json["DECLARATION"],
      idType: json["ID_TYPE"],
      aggrId: json["AGGR_ID"]);

  Map<String, dynamic> toJson(PrimaryMember primaryMember) => {
        "FIRST_NAME": primaryMember.firstName,
        "LAST_NAME": primaryMember.lastName,
        "MOBILE": primaryMember.mobile,
        "ID": primaryMember.idCardNumber,
        "ACTIVE_STATUS": primaryMember.activeStatus,
        "DOB": primaryMember.dateOfBirth,
        "STATE_CODE": primaryMember.stateCode,
        "DISTRICT_CODE": primaryMember.districtCode,
        "ASSEMBLY_CODE": primaryMember.assemblyCode,
        "BOOTH_CODE": primaryMember.boothCode,
        "TMP_ID": primaryMember.tmpId,
        "REFERRER_ID": primaryMember.refererId,
        "CREATED_BY": primaryMember.createdBy,
        "CREATED_ON": primaryMember.createdOn,
        "BATCH_NO": primaryMember.batchNumber,
        "MEMBER_ID": primaryMember.memberId,
        "DECLARATION": primaryMember.declaration,
        "ID_TYPE": primaryMember.idType,
        "AGGR_ID": primaryMember.aggrId
      };
}
