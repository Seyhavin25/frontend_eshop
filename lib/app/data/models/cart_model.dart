// Helper functions for safe type conversion
num? _toNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  return num.tryParse(value.toString());
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? double.tryParse(value.toString())?.toInt();
}

class Cart {
  int? id;
  int? userId;
  String? status;
  num? total; // ✅ was int? — Laravel decimal cast sends this as a string
  String? createdAt;
  String? updatedAt;
  List<CartItems>? cartItems;

  Cart(
      {this.id,
        this.userId,
        this.status,
        this.total,
        this.createdAt,
        this.updatedAt,
        this.cartItems});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    status = json['status'];
    total = _toNum(json['total']); // ✅ safe parse
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['items'] != null) {
      cartItems = <CartItems>[];
      json['items'].forEach((v) {
        cartItems!.add(new CartItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['status'] = this.status;
    data['total'] = this.total;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.cartItems != null) {
      data['items'] = this.cartItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItems {
  int? id;
  int? cartId;
  int? productId;
  num? quantity;
  num? price;
  String? createdAt;
  String? updatedAt;
  Product? product;

  CartItems(
      {this.id,
        this.cartId,
        this.productId,
        this.quantity,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.product});

  CartItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cartId = json['cart_id'];
    productId = json['product_id'];
    quantity = _toNum(json['quantity']); // ✅ safe parse
    price = _toNum(json['price']); // ✅ safe parse — this fixes your current crash
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cart_id'] = this.cartId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class Product {
  int? id;
  int? categoryId;
  String? name;
  String? description;
  num? price; // ✅ was int? — made defensive in case cast changes
  String? image;
  String? createdAt;
  String? updatedAt;

  Product(
      {this.id,
        this.categoryId,
        this.name,
        this.description,
        this.price,
        this.image,
        this.createdAt,
        this.updatedAt});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    description = json['description'];
    price = _toNum(json['price']);
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}