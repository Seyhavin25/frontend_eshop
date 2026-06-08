class ListProductByCate {
  int? id;
  String? name;
  int? categoryId;
  String? description;
  int? price;
  String? image;
  String? createdAt;
  String? updatedAt;

  ListProductByCate(
      {this.id,
        this.name,
        this.categoryId,
        this.description,
        this.price,
        this.image,
        this.createdAt,
        this.updatedAt});

  ListProductByCate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['category_id'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category_id'] = this.categoryId;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
