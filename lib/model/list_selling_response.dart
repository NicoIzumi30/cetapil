class ListSellingResponse {
  String? status;
  String? message;
  List<Data>? data;

  ListSellingResponse({this.status, this.message, this.data});

  ListSellingResponse.fromJson(Map<String, dynamic> json) {
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
  }

  static List<ListSellingResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(ListSellingResponse.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  String? id;
  User? user;
  String? outletName;
  String? categoryOutlet;
  List<Products>? products;
  String? longitude;
  String? latitude;
  String? filename;
  String? image;
  String? createdAt;
  bool? isDrafted;

  Data(
      {this.id,
        this.user,
        this.outletName,
        this.categoryOutlet,
        this.products,
        this.longitude,
        this.latitude,
        this.filename,
        this.image,
        this.createdAt,
        this.isDrafted});

  Data.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["user"] is Map) {
      user = json["user"] == null ? null : User.fromJson(json["user"]);
    }
    if (json["outlet_name"] is String) {
      outletName = json["outlet_name"];
    }
    if (json["category_outlet"] is String) {
      categoryOutlet = json["category_outlet"];
    }
    if (json["products"] is List) {
      products = json["products"] == null
          ? null
          : (json["products"] as List).map((e) => Products.fromJson(e)).toList();
    }
    if (json["longitude"] is String) {
      longitude = json["longitude"];
    }
    if (json["latitude"] is String) {
      latitude = json["latitude"];
    }
    if (json["filename"] is String) {
      filename = json["filename"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    isDrafted = json["is_drafted"] ?? false;
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (user != null) {
      _data["user"] = user?.toJson();
    }
    _data["outlet_name"] = outletName;
    _data["category_outlet"] = categoryOutlet;
    if (products != null) {
      _data["products"] = products?.map((e) => e.toJson()).toList();
    }
    _data["longitude"] = longitude;
    _data["latitude"] = latitude;
    _data["filename"] = filename;
    _data["image"] = image;
    _data["created_at"] = createdAt;
    _data["is_drafted"] = isDrafted;
    return _data;
  }
}

class Products {
  String? id;
  String? productId;
  Category? category;
  String? productName;
  int? stock;
  int? selling;
  int? balance;
  int? price;

  Products({
    this.id,
    this.productId,
    this.category,
    this.productName,
    this.stock,
    this.selling,
    this.balance,
    this.price,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json["id"] as String?;
    productId = json["product_id"] as String?;
    category = json["category"] == null ? null : Category.fromJson(json["category"]);
    productName = json["product_name"] as String?;
    stock = json["stock"] as int?;
    selling = json["selling"] as int?;
    balance = json["balance"] as int?;
    price = json["price"] as int?;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId,
    "category": category?.toJson(),
    "product_name": productName,
    "stock": stock,
    "selling": selling,
    "balance": balance,
    "price": price,
  };
}

class Category {
  String? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json["id"] as String?;
    name = json["name"] as String?;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class User {
  String? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
  }

  static List<User> fromList(List<Map<String, dynamic>> list) {
    return list.map(User.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}
