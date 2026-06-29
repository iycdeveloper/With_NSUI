import 'package:meta/meta.dart';
import 'dart:convert';

class NominationMember {
  NominationMember({
    this.id,
    this.memberId,
    this.firstName,
    this.lastName,
    this.contestingFor,
    this.amount,
    this.paymentStatus,
    this.category,
    this.gender,
    this.bplCard,
    this.level,
    this.bsn,
    this.stateCode,
    this.districtCode,
    this.assemblyCode,
    this.mandalamCode,
    this.blockCode,
  });

  final String? id;
  final String? memberId;
  final String? firstName;
  final String? lastName;
  final String? contestingFor;
  final String? amount;
  final String? paymentStatus;
  final String? category;
  final String? gender;
  final String? bplCard;
  final String? level;
  final String? bsn;
  final String? stateCode;
  final String? districtCode;
  final String? assemblyCode;
  final String? mandalamCode;
  final String? blockCode;

  NominationMember copyWith({
    String? id,
    String? memberId,
    String? firstName,
    String? lastName,
    String? contestingFor,
    String? amount,
    String? paymentStatus,
    String? category,
    String? gender,
    String? bplCard,
    String? level,
    String? bsn,
    String? stateCode,
    String? districtCode,
    String? assemblyCode,
    String? mandalamCode,
    String? blockCode,
  }) =>
      NominationMember(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        contestingFor: contestingFor ?? this.contestingFor,
        amount: amount ?? this.amount,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        category: category ?? this.category,
        gender: gender ?? this.gender,
        bplCard: bplCard ?? this.bplCard,
        level: level ?? this.level,
        bsn: bsn ?? this.bsn,
        stateCode: stateCode ?? this.stateCode,
        districtCode: districtCode ?? this.districtCode,
        assemblyCode: assemblyCode ?? this.assemblyCode,
        mandalamCode: mandalamCode ?? this.mandalamCode,
        blockCode: blockCode ?? this.blockCode,
      );

  factory NominationMember.fromRawJson(String str) =>
      NominationMember.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NominationMember.fromJson(Map<String, dynamic> json) =>
      NominationMember(
        id: json["ID"],
        memberId: json["MEMBER_ID"],
        firstName: json["FIRST_NAME"],
        lastName: json["LAST_NAME"],
        contestingFor: json["CONTESTING_FOR"],
        amount: json["AMOUNT"],
        paymentStatus: json["PAYMENT_STATUS"],
        category: json["CATEGORY"],
        gender: json["GENDER"],
        bplCard: json["BPL_CARD"],
        level: json["LEVEL"],
        bsn: json["BSN"],
        stateCode: json["STATE_CODE"],
        districtCode: json["DISTRICT_CODE"],
        assemblyCode: json["ASSEMBLY_CODE"],
        mandalamCode: json["MANDALAM_CODE"],
        blockCode: json["BLOCK_CODE"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "MEMBER_ID": memberId,
        "FIRST_NAME": firstName,
        "LAST_NAME": lastName,
        "CONTESTING_FOR": contestingFor,
        "AMOUNT": amount,
        "PAYMENT_STATUS": paymentStatus,
        "CATEGORY": category,
        "GENDER": gender,
        "BPL_CARD": bplCard,
        "LEVEL": level,
        "BSN": bsn,
        "STATE_CODE": stateCode,
        "DISTRICT_CODE": districtCode,
        "ASSEMBLY_CODE": assemblyCode,
        "MANDALAM_CODE": mandalamCode,
        "BLOCK_CODE": blockCode,
      };
}
