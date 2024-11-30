
class ListProductSkuResponse {
  String? status;
  String? message;
  List<Data>? data;

  ListProductSkuResponse({this.status, this.message, this.data});

  ListProductSkuResponse.fromJson(Map<String, dynamic> json) {
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

  static List<ListProductSkuResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(ListProductSkuResponse.fromJson).toList();
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
  String? sku;
  Category? category;
  dynamic averageStock;
  int? mdPrice;
  int? salesPrice;
  List<dynamic>? channelAv3M;

  Data({this.id, this.sku, this.category, this.averageStock, this.mdPrice, this.salesPrice, this.channelAv3M});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["sku"] is String) {
      sku = json["sku"];
    }
    if(json["category"] is Map) {
      category = json["category"] == null ? null : Category.fromJson(json["category"]);
    }
    averageStock = json["average_stock"];
    if(json["md_price"] is int) {
      mdPrice = json["md_price"];
    }
    if(json["sales_price"] is int) {
      salesPrice = json["sales_price"];
    }
    if(json["channel_av3m"] is List) {
      channelAv3M = json["channel_av3m"] ?? [];
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["sku"] = sku;
    if(category != null) {
      _data["category"] = category?.toJson();
    }
    _data["average_stock"] = averageStock;
    _data["md_price"] = mdPrice;
    _data["sales_price"] = salesPrice;
    if(channelAv3M != null) {
      _data["channel_av3m"] = channelAv3M;
    }
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