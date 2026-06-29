class BatchDataModel {
  late String batchId;
  late int countAM;
  String? paymentStatus;
  String? stateCode;
  String? districtCode;
  String? syncStatus;
  String? onhold;
  late bool selected;

  String? aggrId;
  DateTime? createdOn;
  String? paymentOn;
  String? amount;
  String? paymentId;
  BatchDataModel(
      {required this.batchId,
      required this.countAM,
      this.districtCode,
      this.stateCode,
      this.paymentStatus,
      this.syncStatus,
      this.onhold,
      this.selected = false,
      this.aggrId,
      this.amount,
      this.createdOn,
      this.paymentId,
      this.paymentOn});

  factory BatchDataModel.fromMap(Map<dynamic, dynamic> json) => BatchDataModel(
      aggrId: json["AGGR_ID"],
      countAM: json['TOTAL_AM'],
      batchId: json["BATCH_NO"],
      createdOn: json["CREATED_ON"] != null
          ? DateTime.parse(json["CREATED_ON"])
          : null,
      paymentStatus: (json["PAYMENT_STATUS"] ?? "").isEmpty
          ? "Pending"
          : json["PAYMENT_STATUS"],
      paymentOn: json["PAYMENT_ON"],
      stateCode: json["STATE_CODE"],
      districtCode: json["DISTRICT_CODE"],
      amount: json["AMOUNT"],
      paymentId: json["PAYMENT_ID"],
      onhold: json["ONHOLD"],
      syncStatus: json['SYNC_STATUS']);

  factory BatchDataModel.fromScrutinyMap(Map<dynamic, dynamic> json) =>
      BatchDataModel(
          aggrId: json["AGGR_ID"],
          countAM: json['TOTALAM'] is int
              ? json['TOTALAM']
              : int.parse(json['TOTALAM']),
          batchId: json["BATCH_NO"],
          createdOn: json["CREATED_ON"] != null
              ? DateTime.parse(json["CREATED_ON"])
              : null,
          paymentStatus: (json["PAYMENT_STATUS"] ?? "").isEmpty
              ? "Pending"
              : json["PAYMENT_STATUS"],
          paymentOn: json["PAYMENT_ON"],
          stateCode: json["STATE_CODE"],
          districtCode: json["DISTRICT_CODE"],
          amount: json["AMOUNT"],
          paymentId: json["PAYMENT_ID"],
          onhold: json["ONHOLD"]?.toString(),
          syncStatus: "0");

  //
  // {
  //   this.selected = false;
  // }

  Map<String, Object?> toJson() => {
        if (aggrId != null) "AGGR_ID": aggrId,
        "BATCH_NO": batchId,
        if (createdOn != null) "CREATED_ON": createdOn?.toIso8601String(),
        if (paymentStatus != null) "PAYMENT_STATUS": paymentStatus,
        if (paymentOn != null) "PAYMENT_ON": paymentOn,
        if (stateCode != null) "STATE_CODE": stateCode,
        if (districtCode != null) "DISTRICT_CODE": districtCode,
        if (amount != null) "AMOUNT": amount,
        if (paymentId != null) "PAYMENT_ID": paymentId,
        if (countAM != null) "TOTAL_AM": countAM,
        if (syncStatus != null) "SYNC_STATUS": syncStatus,
        if (onhold != null) "ONHOLD": onhold,
      };
}
