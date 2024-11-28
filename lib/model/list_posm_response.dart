/// status : "OK"
/// message : "Get the Posm type list successfully."
/// data : [{"id":"9d783acb-d5fd-40d3-b97a-2b741555fa0f","name":"Backwall"},{"id":"9d783acb-d8b1-4bec-b769-e7bbf17d2f09","name":"Standee"},{"id":"9d783acb-dab1-493d-bdee-0a9bb5abfd27","name":"Glorifier"},{"id":"9d783acb-dce1-4d18-ada0-a9752dc06566","name":"COC"}]

class ListPosmResponse {
  ListPosmResponse({
      String? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ListPosmResponse.fromJson(dynamic json) {
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
ListPosmResponse copyWith({  String? status,
  String? message,
  List<Data>? data,
}) => ListPosmResponse(  status: status ?? _status,
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

/// id : "9d783acb-d5fd-40d3-b97a-2b741555fa0f"
/// name : "Backwall"

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