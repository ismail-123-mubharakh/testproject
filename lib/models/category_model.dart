
class CategoryModel {
  String? status;
  String? message;
  List<String>? categories;

  CategoryModel({
    this.status,
    this.message,
    this.categories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    status: json["status"],
    message: json["message"],
    categories: List<String>.from(json["categories"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "categories": List<dynamic>.from(categories!.map((x) => x)),
  };
}
