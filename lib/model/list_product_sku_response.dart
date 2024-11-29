/// status : "OK"
/// message : "Get the product list successfully."
/// data : [{"id":"9d783aca-ff0c-4e1e-960f-460634498e52","sku":"CETAPHIL GENTLE SKIN CLEANSER 1000 ML","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d783acb-0152-419e-a232-8b18ad01478d","sku":"CETAPHIL GENTLE SKIN CLEANSER 125 ML","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d783acb-0340-4a49-8cec-ebfb21cd3fd4","sku":"CETAPHIL GENTLE SKIN CLEANSER 250 ML","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d783acb-0513-4cde-aeca-f1374987b133","sku":"CETAPHIL GENTLE SKIN CLEANSER 500 ML","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d783acb-070d-4c5d-8d63-2db0607448d8","sku":"CETAPHIL GENTLE SKIN CLEANSER 59 ML","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d783acb-0951-49be-8f27-626a3444e388","sku":"CETAPHIL OILY SKIN CLEANSER 125 ML","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d783acb-0b22-4dd0-b933-fe25d05fa469","sku":"CETAPHIL ULTRA GENTLE BODY WASH 500 ML","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d783acb-1110-4e13-ba9a-43974e89f247","sku":"Cetaphil Brightening Day Protection Cream SPF 50 ML","category":{"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"},"average_stock":null},{"id":"9d783acb-15fa-49c9-b9c5-80270e3d23c9","sku":"Cetaphil Brightness Refresh Toner 150 ML","category":{"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"},"average_stock":null},{"id":"9d783acb-1817-433e-a4f5-6b6b937265f6","sku":"Cetaphil Brightness Reveal Body Wash 245 ML","category":{"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"},"average_stock":null},{"id":"9d783acb-19d3-48c1-94fd-929c044e9e7d","sku":"Cetaphil Brightness Reveal Creamy Cleanser 100 ML","category":{"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"},"average_stock":null},{"id":"9d783acb-3713-43f2-b7d3-59c367c638b8","sku":"CETAPHIL DAILY ADV ULT HYDRA LOTION 85 G","category":{"id":"9d783acb-35b2-41d8-bd85-ef48b34e3585","name":"Moisturizer"},"average_stock":null},{"id":"9d783acb-3921-4df1-a54c-fefe1e820d12","sku":"CETAPHIL MOISTURIZING CREAM 453 G","category":{"id":"9d783acb-35b2-41d8-bd85-ef48b34e3585","name":"Moisturizer"},"average_stock":null},{"id":"9d783acb-3afc-4ecd-98ed-e684c536aabf","sku":"CETAPHIL MOISTURIZING CREAM 100 G","category":{"id":"9d783acb-35b2-41d8-bd85-ef48b34e3585","name":"Moisturizer"},"average_stock":null},{"id":"9d783acb-3d4f-463d-8e4d-899b110c48b7","sku":"CETAPHIL MOISTURIZING LOTION 200 ML","category":{"id":"9d783acb-35b2-41d8-bd85-ef48b34e3585","name":"Moisturizer"},"average_stock":null},{"id":"9d783acb-3f6a-405f-bff0-c078f7f40ad3","sku":"CETAPHIL MOISTURIZING LOTION 59 ML","category":{"id":"9d783acb-35b2-41d8-bd85-ef48b34e3585","name":"Moisturizer"},"average_stock":null},{"id":"9d854d25-4169-4674-afba-ef6b708bcb00","sku":"CETAPHIL Exfoliating Cleanser 170 ML","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d892c3e-2a31-4c8d-bbc3-833b9eaf2692","sku":"oke2","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d8a573a-71a3-4394-b655-bbacc0cf3ee0","sku":"okeeee","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null},{"id":"9d8a8ed7-e5d9-40f2-9b7d-6a4e33e84618","sku":"CETAPHIL GENTLE SKIN CLEANSER 500 ML.","category":{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},"average_stock":null}]

class ListProductSkuResponse {
  ListProductSkuResponse({
      String? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ListProductSkuResponse.fromJson(dynamic json) {
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
ListProductSkuResponse copyWith({  String? status,
  String? message,
  List<Data>? data,
}) => ListProductSkuResponse(  status: status ?? _status,
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

/// id : "9d783aca-ff0c-4e1e-960f-460634498e52"
/// sku : "CETAPHIL GENTLE SKIN CLEANSER 1000 ML"
/// category : {"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"}
/// average_stock : null

class Data {
  Data({
      String? id, 
      String? sku, 
      Category? category, 
      dynamic averageStock,}){
    _id = id;
    _sku = sku;
    _category = category;
    _averageStock = averageStock;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _sku = json['sku'];
    _category = json['category'] != null ? Category.fromJson(json['category']) : null;
    _averageStock = json['average_stock'];
  }
  String? _id;
  String? _sku;
  Category? _category;
  dynamic _averageStock;
Data copyWith({  String? id,
  String? sku,
  Category? category,
  dynamic averageStock,
}) => Data(  id: id ?? _id,
  sku: sku ?? _sku,
  category: category ?? _category,
  averageStock: averageStock ?? _averageStock,
);
  String? get id => _id;
  String? get sku => _sku;
  Category? get category => _category;
  dynamic get averageStock => _averageStock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sku'] = _sku;
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    map['average_stock'] = _averageStock;
    return map;
  }

}

/// id : "9d783aca-fa71-40d1-b7b5-6b32f5913969"
/// name : "Cleanser"

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