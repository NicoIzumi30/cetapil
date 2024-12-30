
class ListSellingResponse {
  String? status;
  String? message;
  List<Data>? data;

  ListSellingResponse({this.status, this.message, this.data});

  ListSellingResponse.fromJson(Map<String, dynamic> json) {
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
  }

  static List<ListSellingResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(ListSellingResponse.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  String? id;
  User? user;
  Outlet? outlet;
  List<Products>? products;
  String? longitude;
  String? latitude;
  String? filename;
  String? image;
  String? createdAt;
  String? checkedIn;
  String? checkedOut;
  int? duration;
  bool? isDrafted;

  Data({this.id, this.user, this.outlet, this.products, this.longitude, this.latitude, this.filename, this.image, this.createdAt, this.checkedIn, this.checkedOut, this.duration,this.isDrafted});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["user"] is Map) {
      user = json["user"] == null ? null : User.fromJson(json["user"]);
    }
    if(json["outlet"] is Map) {
      outlet = json["outlet"] == null ? null : Outlet.fromJson(json["outlet"]);
    }
    if(json["products"] is List) {
      products = json["products"] == null ? null : (json["products"] as List).map((e) => Products.fromJson(e)).toList();
    }
    if(json["longitude"] is String) {
      longitude = json["longitude"];
    }
    if(json["latitude"] is String) {
      latitude = json["latitude"];
    }
    if(json["filename"] is String) {
      filename = json["filename"];
    }
    if(json["image"] is String) {
      image = json["image"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if(json["checked_in"] is String) {
      checkedIn = json["checked_in"];
    }
    if(json["checked_out"] is String) {
      checkedOut = json["checked_out"];
    }
    if(json["duration"] is int) {
      duration = json["duration"];
    }
    isDrafted = json["is_drafted"] ?? false;
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if(user != null) {
      _data["user"] = user?.toJson();
    }
    if(outlet != null) {
      _data["outlet"] = outlet?.toJson();
    }
    if(products != null) {
      _data["products"] = products?.map((e) => e.toJson()).toList();
    }
    _data["longitude"] = longitude;
    _data["latitude"] = latitude;
    _data["filename"] = filename;
    _data["image"] = image;
    _data["created_at"] = createdAt;
    _data["checked_in"] = checkedIn;
    _data["checked_out"] = checkedOut;
    _data["duration"] = duration;
    _data["is_drafted"] = isDrafted;

    return _data;
  }
}

class Products {
  String? id;
  String? productId;
  Category? category;
  String? productName;
  int? qty;
  int? price;
  int? total;

  Products({this.id, this.productId, this.category, this.productName, this.qty, this.price, this.total});

  Products.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["product_id"] is String) {
      productId = json["product_id"];
    }
    if(json["category"] is Map) {
      category = json["category"] == null ? null : Category.fromJson(json["category"]);
    }
    if(json["product_name"] is String) {
      productName = json["product_name"];
    }
    if(json["qty"] is int) {
      qty = json["qty"];
    }
    if(json["price"] is int) {
      price = json["price"];
    }
    if(json["total"] is int) {
      total = json["total"];
    }
  }

  static List<Products> fromList(List<Map<String, dynamic>> list) {
    return list.map(Products.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["product_id"] = productId;
    if(category != null) {
      _data["category"] = category?.toJson();
    }
    _data["product_name"] = productName;
    _data["qty"] = qty;
    _data["price"] = price;
    _data["total"] = total;
    return _data;
  }
}

class Category {
  String? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  static List<Category> fromList(List<Map<String, dynamic>> list) {
    return list.map(Category.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}

class Outlet {
  String? id;
  String? name;

  Outlet({this.id, this.name});

  Outlet.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  static List<Outlet> fromList(List<Map<String, dynamic>> list) {
    return list.map(Outlet.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}

class User {
  String? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
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