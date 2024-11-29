/// status : "OK"
/// message : "Get the channel list successfully."
/// data : [{"id":"9d883c18-d373-4e16-a89d-c3959c4479e9","name":"Chain Pharmacy"},{"id":"9d883c18-d732-4313-ae4b-6c11acb9ac7a","name":"Minimarket"},{"id":"9d883c18-d831-4dca-a444-0ca859b96eff","name":"HFS/GT"},{"id":"9d883c18-d9ce-4dca-a5f9-7cd0ba9209fe","name":"HSM (Hyper Suparmarket)"}]

class ListChannelResponse {
  ListChannelResponse({
      String? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ListChannelResponse.fromJson(dynamic json) {
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
ListChannelResponse copyWith({  String? status,
  String? message,
  List<Data>? data,
}) => ListChannelResponse(  status: status ?? _status,
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

/// id : "9d883c18-d373-4e16-a89d-c3959c4479e9"
/// name : "Chain Pharmacy"

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