/// status : "OK"
/// message : "Outlet created successfully."
/// data : {"id":"9d8d178f-43e0-4155-bf57-c26773860be1","user":{"id":"9d783aca-c21b-45e4-8e27-6f4b829922a3","name":"Sales 1","email":"sales1@gmail.com","phone_number":"+628123456789"},"name":"a","category":"a","visit_day":"1","longitude":"100.11","latitude":"-2.1232","city":{"id":"8b31acdf-046d-42e6-9f62-c40bc08dabbf","name":"KABUPATEN LUMAJANG"},"address":"yogyakarta","status":"PENDING","week_type":null,"cycle":"1x1","images":[{"id":"9d8d178f-4b46-4986-96aa-f5da80398b4e","position":1,"filename":"big-sur-coastline-l.jpg","image":"/storage/images/outlets/9d8d178f-43e0-4155-bf57-c26773860be1/big_sur_coastline_l_1732293112.jpg"},{"id":"9d8d178f-4ca0-4824-a614-71e1ecf5abb4","position":2,"filename":"big-sur-coastline-l.jpg","image":"/storage/images/outlets/9d8d178f-43e0-4155-bf57-c26773860be1/big_sur_coastline_l_1732293112.jpg"},{"id":"9d8d178f-4ddb-412d-95d4-17500e716830","position":3,"filename":"big-sur-coastline-l.jpg","image":"/storage/images/outlets/9d8d178f-43e0-4155-bf57-c26773860be1/big_sur_coastline_l_1732293112.jpg"}],"forms":[{"id":"9d8d178f-4e5b-4d23-be88-de363cafdd37","outletForm":{"id":"9d783acb-8187-42f3-93ad-b8e138db9978","type":"text","question":"Berapa SKU GIH yang dijual"},"answer":"This is answer for form 1"}]}

class SubmitOutletResponse {
  SubmitOutletResponse({
      String? status, 
      String? message, 
      Data? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  SubmitOutletResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? _status;
  String? _message;
  Data? _data;
SubmitOutletResponse copyWith({  String? status,
  String? message,
  Data? data,
}) => SubmitOutletResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  String? get status => _status;
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

/// id : "9d8d178f-43e0-4155-bf57-c26773860be1"
/// user : {"id":"9d783aca-c21b-45e4-8e27-6f4b829922a3","name":"Sales 1","email":"sales1@gmail.com","phone_number":"+628123456789"}
/// name : "a"
/// category : "a"
/// visit_day : "1"
/// longitude : "100.11"
/// latitude : "-2.1232"
/// city : {"id":"8b31acdf-046d-42e6-9f62-c40bc08dabbf","name":"KABUPATEN LUMAJANG"}
/// address : "yogyakarta"
/// status : "PENDING"
/// week_type : null
/// cycle : "1x1"
/// images : [{"id":"9d8d178f-4b46-4986-96aa-f5da80398b4e","position":1,"filename":"big-sur-coastline-l.jpg","image":"/storage/images/outlets/9d8d178f-43e0-4155-bf57-c26773860be1/big_sur_coastline_l_1732293112.jpg"},{"id":"9d8d178f-4ca0-4824-a614-71e1ecf5abb4","position":2,"filename":"big-sur-coastline-l.jpg","image":"/storage/images/outlets/9d8d178f-43e0-4155-bf57-c26773860be1/big_sur_coastline_l_1732293112.jpg"},{"id":"9d8d178f-4ddb-412d-95d4-17500e716830","position":3,"filename":"big-sur-coastline-l.jpg","image":"/storage/images/outlets/9d8d178f-43e0-4155-bf57-c26773860be1/big_sur_coastline_l_1732293112.jpg"}]
/// forms : [{"id":"9d8d178f-4e5b-4d23-be88-de363cafdd37","outletForm":{"id":"9d783acb-8187-42f3-93ad-b8e138db9978","type":"text","question":"Berapa SKU GIH yang dijual"},"answer":"This is answer for form 1"}]

class Data {
  Data({
      String? id, 
      User? user, 
      String? name, 
      String? category, 
      String? visitDay, 
      String? longitude, 
      String? latitude, 
      City? city, 
      String? address, 
      String? status, 
      dynamic weekType, 
      String? cycle, 
      List<Images>? images, 
      List<Forms>? forms,}){
    _id = id;
    _user = user;
    _name = name;
    _category = category;
    _visitDay = visitDay;
    _longitude = longitude;
    _latitude = latitude;
    _city = city;
    _address = address;
    _status = status;
    _weekType = weekType;
    _cycle = cycle;
    _images = images;
    _forms = forms;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _name = json['name'];
    _category = json['category'];
    _visitDay = json['visit_day'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _city = json['city'] != null ? City.fromJson(json['city']) : null;
    _address = json['address'];
    _status = json['status'];
    _weekType = json['week_type'];
    _cycle = json['cycle'];
    if (json['images'] != null) {
      _images = [];
      json['images'].forEach((v) {
        _images?.add(Images.fromJson(v));
      });
    }
    if (json['forms'] != null) {
      _forms = [];
      json['forms'].forEach((v) {
        _forms?.add(Forms.fromJson(v));
      });
    }
  }
  String? _id;
  User? _user;
  String? _name;
  String? _category;
  String? _visitDay;
  String? _longitude;
  String? _latitude;
  City? _city;
  String? _address;
  String? _status;
  dynamic _weekType;
  String? _cycle;
  List<Images>? _images;
  List<Forms>? _forms;
Data copyWith({  String? id,
  User? user,
  String? name,
  String? category,
  String? visitDay,
  String? longitude,
  String? latitude,
  City? city,
  String? address,
  String? status,
  dynamic weekType,
  String? cycle,
  List<Images>? images,
  List<Forms>? forms,
}) => Data(  id: id ?? _id,
  user: user ?? _user,
  name: name ?? _name,
  category: category ?? _category,
  visitDay: visitDay ?? _visitDay,
  longitude: longitude ?? _longitude,
  latitude: latitude ?? _latitude,
  city: city ?? _city,
  address: address ?? _address,
  status: status ?? _status,
  weekType: weekType ?? _weekType,
  cycle: cycle ?? _cycle,
  images: images ?? _images,
  forms: forms ?? _forms,
);
  String? get id => _id;
  User? get user => _user;
  String? get name => _name;
  String? get category => _category;
  String? get visitDay => _visitDay;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  City? get city => _city;
  String? get address => _address;
  String? get status => _status;
  dynamic get weekType => _weekType;
  String? get cycle => _cycle;
  List<Images>? get images => _images;
  List<Forms>? get forms => _forms;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['name'] = _name;
    map['category'] = _category;
    map['visit_day'] = _visitDay;
    map['longitude'] = _longitude;
    map['latitude'] = _latitude;
    if (_city != null) {
      map['city'] = _city?.toJson();
    }
    map['address'] = _address;
    map['status'] = _status;
    map['week_type'] = _weekType;
    map['cycle'] = _cycle;
    if (_images != null) {
      map['images'] = _images?.map((v) => v.toJson()).toList();
    }
    if (_forms != null) {
      map['forms'] = _forms?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "9d8d178f-4e5b-4d23-be88-de363cafdd37"
/// outletForm : {"id":"9d783acb-8187-42f3-93ad-b8e138db9978","type":"text","question":"Berapa SKU GIH yang dijual"}
/// answer : "This is answer for form 1"

class Forms {
  Forms({
      String? id, 
      OutletForm? outletForm, 
      String? answer,}){
    _id = id;
    _outletForm = outletForm;
    _answer = answer;
}

  Forms.fromJson(dynamic json) {
    _id = json['id'];
    _outletForm = json['outletForm'] != null ? OutletForm.fromJson(json['outletForm']) : null;
    _answer = json['answer'];
  }
  String? _id;
  OutletForm? _outletForm;
  String? _answer;
Forms copyWith({  String? id,
  OutletForm? outletForm,
  String? answer,
}) => Forms(  id: id ?? _id,
  outletForm: outletForm ?? _outletForm,
  answer: answer ?? _answer,
);
  String? get id => _id;
  OutletForm? get outletForm => _outletForm;
  String? get answer => _answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_outletForm != null) {
      map['outletForm'] = _outletForm?.toJson();
    }
    map['answer'] = _answer;
    return map;
  }

}

/// id : "9d783acb-8187-42f3-93ad-b8e138db9978"
/// type : "text"
/// question : "Berapa SKU GIH yang dijual"

class OutletForm {
  OutletForm({
      String? id, 
      String? type, 
      String? question,}){
    _id = id;
    _type = type;
    _question = question;
}

  OutletForm.fromJson(dynamic json) {
    _id = json['id'];
    _type = json['type'];
    _question = json['question'];
  }
  String? _id;
  String? _type;
  String? _question;
OutletForm copyWith({  String? id,
  String? type,
  String? question,
}) => OutletForm(  id: id ?? _id,
  type: type ?? _type,
  question: question ?? _question,
);
  String? get id => _id;
  String? get type => _type;
  String? get question => _question;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['type'] = _type;
    map['question'] = _question;
    return map;
  }

}

/// id : "9d8d178f-4b46-4986-96aa-f5da80398b4e"
/// position : 1
/// filename : "big-sur-coastline-l.jpg"
/// image : "/storage/images/outlets/9d8d178f-43e0-4155-bf57-c26773860be1/big_sur_coastline_l_1732293112.jpg"

class Images {
  Images({
      String? id, 
      num? position, 
      String? filename, 
      String? image,}){
    _id = id;
    _position = position;
    _filename = filename;
    _image = image;
}

  Images.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
    _filename = json['filename'];
    _image = json['image'];
  }
  String? _id;
  num? _position;
  String? _filename;
  String? _image;
Images copyWith({  String? id,
  num? position,
  String? filename,
  String? image,
}) => Images(  id: id ?? _id,
  position: position ?? _position,
  filename: filename ?? _filename,
  image: image ?? _image,
);
  String? get id => _id;
  num? get position => _position;
  String? get filename => _filename;
  String? get image => _image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    map['filename'] = _filename;
    map['image'] = _image;
    return map;
  }

}

/// id : "8b31acdf-046d-42e6-9f62-c40bc08dabbf"
/// name : "KABUPATEN LUMAJANG"

class City {
  City({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  City.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  String? _id;
  String? _name;
City copyWith({  String? id,
  String? name,
}) => City(  id: id ?? _id,
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

/// id : "9d783aca-c21b-45e4-8e27-6f4b829922a3"
/// name : "Sales 1"
/// email : "sales1@gmail.com"
/// phone_number : "+628123456789"

class User {
  User({
      String? id, 
      String? name, 
      String? email, 
      String? phoneNumber,}){
    _id = id;
    _name = name;
    _email = email;
    _phoneNumber = phoneNumber;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phoneNumber = json['phone_number'];
  }
  String? _id;
  String? _name;
  String? _email;
  String? _phoneNumber;
User copyWith({  String? id,
  String? name,
  String? email,
  String? phoneNumber,
}) => User(  id: id ?? _id,
  name: name ?? _name,
  email: email ?? _email,
  phoneNumber: phoneNumber ?? _phoneNumber,
);
  String? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phone_number'] = _phoneNumber;
    return map;
  }

}