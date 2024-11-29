/// status : "OK"
/// message : "Get the category list successfully"
/// data : [{"id":"9d783aca-fa71-40d1-b7b5-6b32f5913969","name":"Cleanser"},{"id":"9d783acb-0d66-4f00-ba98-fab2a43a7f07","name":"BHR"},{"id":"9d783acb-1bde-41f7-b6c0-4b9947b09727","name":"Baby Calendula"},{"id":"9d783acb-2369-460f-9ab5-0cf4fec92c00","name":"Baby Classic"},{"id":"9d783acb-35b2-41d8-bd85-ef48b34e3585","name":"Moisturizer"}]

class ListCategoryResponse {
  ListCategoryResponse({
      String? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ListCategoryResponse.fromJson(dynamic json) {
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
ListCategoryResponse copyWith({  String? status,
  String? message,
  List<Data>? data,
}) => ListCategoryResponse(  status: status ?? _status,
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

/// id : "9d783aca-fa71-40d1-b7b5-6b32f5913969"
/// name : "Cleanser"

class Data {
  Data({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  String? _id;
  String? _name;
Data copyWith({  String? id,
  String? name,
}) => Data(  id: id ?? _id,
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