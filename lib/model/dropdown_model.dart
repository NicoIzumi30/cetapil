/// status : "OK"
/// data : [{"id":"9d783acb-de36-4140-834f-ba7ca0ed6d27","name":"We do skin, you do you"},{"id":"9d783acb-e028-4836-b81f-b34f01e7b5bb","name":"New soothing foam wash"},{"id":"9d783acb-e1e8-47ed-ad20-7db3d6f73297","name":"Bright Healty Radiance"},{"id":"9d895fd8-5f6b-43cc-8ef2-4b996804f1aa","name":"test oke"}]

class DropdownModel {
  DropdownModel({
      String? status, 
      List<Data>? data,}){
    _status = status;
    _data = data;
}

  DropdownModel.fromJson(dynamic json) {
    _status = json['status'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  String? _status;
  List<Data>? _data;
DropdownModel copyWith({  String? status,
  List<Data>? data,
}) => DropdownModel(  status: status ?? _status,
  data: data ?? _data,
);
  String? get status => _status;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "9d783acb-de36-4140-834f-ba7ca0ed6d27"
/// name : "We do skin, you do you"

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