class States {
  final int id;
  final String name;
  final String stateCode;
  final String isEnabled;
  final String? isPrimary;
  static final columns = [
    "ID",
    "STATE_NAME",
    "MASTER_STATE_CODE",
    "IS_ENABLED"
  ];
  States(
      {required this.id,
      required this.name,
      required this.stateCode,
      required this.isEnabled,
      this.isPrimary});
  factory States.fromMap(Map<String, dynamic> data) {
    return States(
      id: data['ID'],
      name: data['STATE_NAME'],
      stateCode: data['MASTER_STATE_CODE'],
      isEnabled: data['IS_ENABLED'],
      isPrimary: data['IS_PRIMARY'],
    );
  }
  Map<String, dynamic> toMap() => {
        "ID": id,
        "STATE_NAME": name,
        "MASTER_STATE_CODE": stateCode,
        "IS_ENABLED": isEnabled,
      };
}
