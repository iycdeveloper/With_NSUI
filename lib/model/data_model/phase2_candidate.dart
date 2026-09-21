import 'dart:convert';

class Phase2Candidate {
  Phase2Candidate({
    this.csn,
    this.memberId,
    this.firstName,
    this.lastName,
  });

  final String? csn;
  final String? memberId;
  final String? firstName;
  final String? lastName;

  String get displayName => "${firstName ?? ''} ${lastName ?? ''}".trim();

  /// Name plus CSN, for the picker: candidates can share a name, but CSN is
  /// unique, so the dropdown must show it to tell them apart.
  String get displayLabel =>
      csn == null || csn!.isEmpty ? displayName : "$displayName (CSN: $csn)";

  factory Phase2Candidate.fromRawJson(String str) =>
      Phase2Candidate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Phase2Candidate.fromJson(Map<String, dynamic> json) =>
      Phase2Candidate(
        csn: json["CSN"],
        memberId: json["MEMBER_ID"],
        firstName: json["FIRST_NAME"],
        lastName: json["LAST_NAME"],
      );

  Map<String, dynamic> toJson() => {
        "CSN": csn,
        "MEMBER_ID": memberId,
        "FIRST_NAME": firstName,
        "LAST_NAME": lastName,
      };
}
