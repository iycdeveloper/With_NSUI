class CampaignUser {
  CampaignUser({required this.name, required this.mobile, required this.count});

  String name;

  String mobile;

  String count;

  factory CampaignUser.fromJson(Map<String, dynamic> json) => CampaignUser(
        name: "${json["NAME"]}",
        mobile: json["MOBILE"],
        count: json["VERIFIED_COUNT"],
      );
}
