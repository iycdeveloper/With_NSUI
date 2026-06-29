class LegalCellMember {
  final String memberId;
  final String firstName;
  final String lastName;
  final String barCouncilId;
  final String paymentStatus;

  LegalCellMember(
      {required this.memberId,
      required this.firstName,
      required this.lastName,
      required this.barCouncilId,
      required this.paymentStatus});

  factory LegalCellMember.fromJson(Map<String, dynamic> json) =>
      LegalCellMember(
          firstName: json["first_name"],
          lastName: json["last_name"],
          memberId: json["member_id"],
          paymentStatus: json["payment_status"],
          barCouncilId: json["bar_council_number"]);
}

List<LegalCellMember> legalCellMembersListFromJson(List<dynamic> str) =>
    List<LegalCellMember>.from(str.map((x) => LegalCellMember.fromJson(x)));
//{status: SUCCESS, response: [{member_id: IYCLCCG1659340883, first_name: xgd, last_name: fhchd, bar_council_number: fhdgdgdd, payment_status: UNPAID}, {member_id: IYCLCCG1659418969, first_name: Sa, last_name: g, bar_council_number: Qrwydhi, payment_status: UNPAID}]}
