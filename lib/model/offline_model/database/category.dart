class Category {
  final int id;
  final String name;
  final String categoryCode;

  static final columns = [
    "ID",
    "CATEGORY_NAME",
    "CATEGORY_CODE",

  ];
  Category({
    required this.id,
    required this.name,
    required this.categoryCode,
  });
  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      id: data['ID'],
      name: data['CATEGORY_NAME'],
      categoryCode: data['CATEGORY_CODE'],
    );
  }
  Map<String, dynamic> toMap() => {
    "ID": id,
    "CATEGORY_NAME": name,
    "CATEGORY_CODE": categoryCode,
  };
}
