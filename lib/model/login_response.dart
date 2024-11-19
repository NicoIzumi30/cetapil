/// status : true
/// message : "Login successful"
/// data : {"user":{"id":"9d7cc873-c03f-4ebf-af4f-5b7c0d76a314","name":"Sales 1","email":"sales1@gmail.com","phone_number":"+628123456789","longitude":"-79.928219","latitude":"-27.478799","city":null,"region":null,"address":null,"active":true,"email_verified_at":null,"created_at":"2024-11-14T13:57:25.000000Z","updated_at":"2024-11-14T13:57:25.000000Z","deleted_at":null},"token":"7|d6qjC15ZyN93luhCbNrMVkjgy5AhWdpouS2DaLup885ebb4c"}

class LoginResponse {
  LoginResponse({
      bool? status, 
      String? message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  LoginResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _status;
  String? _message;
  Data? _data;
LoginResponse copyWith({  bool? status,
  String? message,
  Data? data,
}) => LoginResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// user : {"id":"9d7cc873-c03f-4ebf-af4f-5b7c0d76a314","name":"Sales 1","email":"sales1@gmail.com","phone_number":"+628123456789","longitude":"-79.928219","latitude":"-27.478799","city":null,"region":null,"address":null,"active":true,"email_verified_at":null,"created_at":"2024-11-14T13:57:25.000000Z","updated_at":"2024-11-14T13:57:25.000000Z","deleted_at":null}
/// token : "7|d6qjC15ZyN93luhCbNrMVkjgy5AhWdpouS2DaLup885ebb4c"

class Data {
  Data({
      User? user, 
      String? token,}){
    _user = user;
    _token = token;
}

  Data.fromJson(dynamic json) {
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _token = json['token'];
  }
  User? _user;
  String? _token;
Data copyWith({  User? user,
  String? token,
}) => Data(  user: user ?? _user,
  token: token ?? _token,
);
  User? get user => _user;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['token'] = _token;
    return map;
  }

}

/// id : "9d7cc873-c03f-4ebf-af4f-5b7c0d76a314"
/// name : "Sales 1"
/// email : "sales1@gmail.com"
/// phone_number : "+628123456789"
/// longitude : "-79.928219"
/// latitude : "-27.478799"
/// city : null
/// region : null
/// address : null
/// active : true
/// email_verified_at : null
/// created_at : "2024-11-14T13:57:25.000000Z"
/// updated_at : "2024-11-14T13:57:25.000000Z"
/// deleted_at : null

class User {
  User({
      String? id, 
      String? name, 
      String? email, 
      String? phoneNumber, 
      String? longitude, 
      String? latitude, 
      dynamic city, 
      dynamic region, 
      dynamic address, 
      bool? active, 
      dynamic emailVerifiedAt, 
      String? createdAt, 
      String? updatedAt, 
      dynamic deletedAt,}){
    _id = id;
    _name = name;
    _email = email;
    _phoneNumber = phoneNumber;
    _longitude = longitude;
    _latitude = latitude;
    _city = city;
    _region = region;
    _address = address;
    _active = active;
    _emailVerifiedAt = emailVerifiedAt;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phoneNumber = json['phone_number'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _city = json['city'];
    _region = json['region'];
    _address = json['address'];
    _active = json['active'];
    _emailVerifiedAt = json['email_verified_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  String? _id;
  String? _name;
  String? _email;
  String? _phoneNumber;
  String? _longitude;
  String? _latitude;
  dynamic _city;
  dynamic _region;
  dynamic _address;
  bool? _active;
  dynamic _emailVerifiedAt;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
User copyWith({  String? id,
  String? name,
  String? email,
  String? phoneNumber,
  String? longitude,
  String? latitude,
  dynamic city,
  dynamic region,
  dynamic address,
  bool? active,
  dynamic emailVerifiedAt,
  String? createdAt,
  String? updatedAt,
  dynamic deletedAt,
}) => User(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  phoneNumber: phoneNumber ?? _phoneNumber,
  longitude: longitude ?? _longitude,
  latitude: latitude ?? _latitude,
  city: city ?? _city,
  region: region ?? _region,
  address: address ?? _address,
  active: active ?? _active,
  emailVerifiedAt: emailVerifiedAt ?? _emailVerifiedAt,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
  deletedAt: deletedAt ?? _deletedAt,
);
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  dynamic get city => _city;
  dynamic get region => _region;
  dynamic get address => _address;
  bool? get active => _active;
  dynamic get emailVerifiedAt => _emailVerifiedAt;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phone_number'] = _phoneNumber;
    map['longitude'] = _longitude;
    map['latitude'] = _latitude;
    map['city'] = _city;
    map['region'] = _region;
    map['address'] = _address;
    map['active'] = _active;
    map['email_verified_at'] = _emailVerifiedAt;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }

}