/// status : "OK"
/// message : "Get the product list successfully."
/// data : [{"id":"9d783acb-1110-4e13-ba9a-43974e89f247","sku":"Cetaphil Brightening Day Protection Cream SPF 50 ML","category":{"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"},"average_stock":null,"product_account_type":null,"filename":null,"image":null,"deleted_at":null},{"id":"9d783acb-15fa-49c9-b9c5-80270e3d23c9","sku":"Cetaphil Brightness Refresh Toner 150 ML","category":{"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"},"average_stock":null,"product_account_type":null,"filename":null,"image":null,"deleted_at":null},{"id":"9d783acb-1817-433e-a4f5-6b6b937265f6","sku":"Cetaphil Brightness Reveal Body Wash 245 ML","category":{"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"},"average_stock":null,"product_account_type":null,"filename":null,"image":null,"deleted_at":null},{"id":"9d783acb-19d3-48c1-94fd-929c044e9e7d","sku":"Cetaphil Brightness Reveal Creamy Cleanser 100 ML","category":{"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"},"average_stock":null,"product_account_type":null,"filename":null,"image":null,"deleted_at":null}]

class ListProductResponse {
  ListProductResponse({
      String? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ListProductResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _status;
  String? _message;
  List<Data>? _data;
ListProductResponse copyWith({  String? status,
  String? message,
  List<Data>? data,
}) => ListProductResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  String? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "9d783acb-1110-4e13-ba9a-43974e89f247"
/// sku : "Cetaphil Brightening Day Protection Cream SPF 50 ML"
/// category : {"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"}
/// average_stock : null
/// product_account_type : null
/// filename : null
/// image : null
/// deleted_at : null

class Data {
  Data({
      String? id, 
      String? sku, 
      Category? category, 
      dynamic averageStock, 
      dynamic productAccountType, 
      dynamic filename, 
      dynamic image, 
      dynamic deletedAt,}){
    _id = id;
    _sku = sku;
    _category = category;
    _averageStock = averageStock;
    _productAccountType = productAccountType;
    _filename = filename;
    _image = image;
    _deletedAt = deletedAt;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _sku = json['sku'];
    _category = json['category'] != null ? Category.fromJson(json['category']) : null;
    _averageStock = json['average_stock'];
    _productAccountType = json['product_account_type'];
    _filename = json['filename'];
    _image = json['image'];
    _deletedAt = json['deleted_at'];
  }
  String? _id;
  String? _sku;
  Category? _category;
  dynamic _averageStock;
  dynamic _productAccountType;
  dynamic _filename;
  dynamic _image;
  dynamic _deletedAt;
Data copyWith({  String? id,
  String? sku,
  Category? category,
  dynamic averageStock,
  dynamic productAccountType,
  dynamic filename,
  dynamic image,
  dynamic deletedAt,
}) => Data(  id: id ?? _id,
  sku: sku ?? _sku,
  category: category ?? _category,
  averageStock: averageStock ?? _averageStock,
  productAccountType: productAccountType ?? _productAccountType,
  filename: filename ?? _filename,
  image: image ?? _image,
  deletedAt: deletedAt ?? _deletedAt,
);
  String? get id => _id;
  String? get sku => _sku;
  Category? get category => _category;
  dynamic get averageStock => _averageStock;
  dynamic get productAccountType => _productAccountType;
  dynamic get filename => _filename;
  dynamic get image => _image;
  dynamic get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sku'] = _sku;
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    map['average_stock'] = _averageStock;
    map['product_account_type'] = _productAccountType;
    map['filename'] = _filename;
    map['image'] = _image;
    map['deleted_at'] = _deletedAt;
    return map;
  }

}

/// id : "9d783acb-0d66-4f00-ba98-fab2a43a7f07"
/// name : "BHR"

class Category {
  Category({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  String? _id;
  String? _name;
Category copyWith({  String? id,
  String? name,
}) => Category(  id: id ?? _id,
  name: name ?? _name,
);
  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

}