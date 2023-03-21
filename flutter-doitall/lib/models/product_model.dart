class ProductModel {
  late int? id;
  late int? companyid;
  late int? userid;
  late double? price;

  late String? name;
  late String? imgproduct;
  late String? category;
  late String? type;
  late String? brand;
  late String? model;
  late String? description;

  ProductModel({
    this.id,
    this.name,
    this.imgproduct,
    this.price,
    this.category,
    this.type,
    this.brand,
    this.model,
    this.companyid,
    this.userid,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      imgproduct: json['img_product'],
      price: json['price'],
      category: json['category'],
      type: json['type'],
      brand: json['brand'],
      model: json['model'],
      userid: json['user_id'],
      companyid: json['company_id'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'img_product': imgproduct,
        'price': price,
        'category': category,
        'type': type,
        'brand': brand,
        'model': model,
        'user_id': userid,
        'company_id': companyid,
        'description': description,
      };
}
