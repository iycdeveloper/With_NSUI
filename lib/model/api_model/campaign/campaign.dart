class Campaign {
  Campaign({required this.id, required this.name, required this.stateCode});

  String id;
  String name;
  String stateCode;

  factory Campaign.fromJson(Map<String, dynamic> json) => Campaign(
      id: json["campaign_id"],
      name: json["campaign_name"],
      stateCode: json["campaign_state_code"]);
}
