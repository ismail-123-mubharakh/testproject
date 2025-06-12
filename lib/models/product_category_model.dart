
class ProductCategoryModel {
  String? status;
  String? message;
  List<Product>? products;

  ProductCategoryModel({
    this.status,
    this.message,
    this.products,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) => ProductCategoryModel(
    status: json["status"],
    message: json["message"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}

class Product {
  int? id;
  String? title;
  String? image;
  int? price;
  String? description;
  String? brand;
  String? model;
  String? color;
  String? category;
  int? discount;
  bool? onSale;
  bool?popular;

  Product({
    this.id,
    this.title,
    this.image,
    this.price,
    this.description,
    this.brand,
    this.model,
    this.color,
    this.category,
    this.discount,
    this.onSale,
    this.popular,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    price: json["price"],
    description: json["description"],
    brand: json["brand"],
    model: json["model"],
    color: json["color"],
    category: json["category"],
    discount: json["discount"],
    onSale: json["onSale"],
    popular: json["popular"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "price": price,
    "description": description,
    "brand": brand,
    "model": model,
    "color": color,
    "category": category,
    "discount": discount,
    "onSale": onSale,
    "popular": popular,
  };
}
