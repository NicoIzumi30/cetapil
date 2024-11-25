/// status : "OK"
/// message : "Get the sales activity list successfully."
/// data : [{"id":"9d925380-92e3-4922-bed5-db944589ebc6","outlet":{"id":"9d8e17e2-1f7f-4989-8562-50092a8e7f9c","name":"Guardian Wonogiri","category":"MT","city_id":"31fd46c7-58b5-41d7-8d1f-0f6fb29a2aeb","longitude":"111.1284155","latitude":"-7.8514865","visit_day":"6"},"user":{"id":"9d783aca-c21b-45e4-8e27-6f4b829922a3","name":"Sales 1"},"checked_in":"2024-11-25 13:58:36","checked_out":null,"views_knowledge":0,"time_availability":0,"time_visibility":0,"time_knowledge":0,"time_survey":0,"time_order":0,"status":"IN_PROGRESS"}]

class ListActivityResponse {
  ListActivityResponse({
      String? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ListActivityResponse.fromJson(dynamic json) {
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
ListActivityResponse copyWith({  String? status,
  String? message,
  List<Data>? data,
}) => ListActivityResponse(  status: status ?? _status,
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

/// id : "9d925380-92e3-4922-bed5-db944589ebc6"
/// outlet : {"id":"9d8e17e2-1f7f-4989-8562-50092a8e7f9c","name":"Guardian Wonogiri","category":"MT","city_id":"31fd46c7-58b5-41d7-8d1f-0f6fb29a2aeb","longitude":"111.1284155","latitude":"-7.8514865","visit_day":"6"}
/// user : {"id":"9d783aca-c21b-45e4-8e27-6f4b829922a3","name":"Sales 1"}
/// checked_in : "2024-11-25 13:58:36"
/// checked_out : null
/// views_knowledge : 0
/// time_availability : 0
/// time_visibility : 0
/// time_knowledge : 0
/// time_survey : 0
/// time_order : 0
/// status : "IN_PROGRESS"

class Data {
  Data({
      String? id, 
      Outlet? outlet, 
      User? user, 
      String? checkedIn, 
      dynamic checkedOut, 
      num? viewsKnowledge, 
      num? timeAvailability, 
      num? timeVisibility, 
      num? timeKnowledge, 
      num? timeSurvey, 
      num? timeOrder, 
      String? status,}){
    _id = id;
    _outlet = outlet;
    _user = user;
    _checkedIn = checkedIn;
    _checkedOut = checkedOut;
    _viewsKnowledge = viewsKnowledge;
    _timeAvailability = timeAvailability;
    _timeVisibility = timeVisibility;
    _timeKnowledge = timeKnowledge;
    _timeSurvey = timeSurvey;
    _timeOrder = timeOrder;
    _status = status;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _outlet = json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null;
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _checkedIn = json['checked_in'];
    _checkedOut = json['checked_out'];
    _viewsKnowledge = json['views_knowledge'];
    _timeAvailability = json['time_availability'];
    _timeVisibility = json['time_visibility'];
    _timeKnowledge = json['time_knowledge'];
    _timeSurvey = json['time_survey'];
    _timeOrder = json['time_order'];
    _status = json['status'];
  }
  String? _id;
  Outlet? _outlet;
  User? _user;
  String? _checkedIn;
  dynamic _checkedOut;
  num? _viewsKnowledge;
  num? _timeAvailability;
  num? _timeVisibility;
  num? _timeKnowledge;
  num? _timeSurvey;
  num? _timeOrder;
  String? _status;
Data copyWith({  String? id,
  Outlet? outlet,
  User? user,
  String? checkedIn,
  dynamic checkedOut,
  num? viewsKnowledge,
  num? timeAvailability,
  num? timeVisibility,
  num? timeKnowledge,
  num? timeSurvey,
  num? timeOrder,
  String? status,
}) => Data(  id: id ?? _id,
  outlet: outlet ?? _outlet,
  user: user ?? _user,
  checkedIn: checkedIn ?? _checkedIn,
  checkedOut: checkedOut ?? _checkedOut,
  viewsKnowledge: viewsKnowledge ?? _viewsKnowledge,
  timeAvailability: timeAvailability ?? _timeAvailability,
  timeVisibility: timeVisibility ?? _timeVisibility,
  timeKnowledge: timeKnowledge ?? _timeKnowledge,
  timeSurvey: timeSurvey ?? _timeSurvey,
  timeOrder: timeOrder ?? _timeOrder,
  status: status ?? _status,
);
  String? get id => _id;
  Outlet? get outlet => _outlet;
  User? get user => _user;
  String? get checkedIn => _checkedIn;
  dynamic get checkedOut => _checkedOut;
  num? get viewsKnowledge => _viewsKnowledge;
  num? get timeAvailability => _timeAvailability;
  num? get timeVisibility => _timeVisibility;
  num? get timeKnowledge => _timeKnowledge;
  num? get timeSurvey => _timeSurvey;
  num? get timeOrder => _timeOrder;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_outlet != null) {
      map['outlet'] = _outlet?.toJson();
    }
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    map['checked_in'] = _checkedIn;
    map['checked_out'] = _checkedOut;
    map['views_knowledge'] = _viewsKnowledge;
    map['time_availability'] = _timeAvailability;
    map['time_visibility'] = _timeVisibility;
    map['time_knowledge'] = _timeKnowledge;
    map['time_survey'] = _timeSurvey;
    map['time_order'] = _timeOrder;
    map['status'] = _status;
    return map;
  }

}

/// id : "9d783aca-c21b-45e4-8e27-6f4b829922a3"
/// name : "Sales 1"

class User {
  User({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  String? _id;
  String? _name;
User copyWith({  String? id,
  String? name,
}) => User(  id: id ?? _id,
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

/// id : "9d8e17e2-1f7f-4989-8562-50092a8e7f9c"
/// name : "Guardian Wonogiri"
/// category : "MT"
/// city_id : "31fd46c7-58b5-41d7-8d1f-0f6fb29a2aeb"
/// longitude : "111.1284155"
/// latitude : "-7.8514865"
/// visit_day : "6"

class Outlet {
  Outlet({
      String? id, 
      String? name, 
      String? category, 
      String? cityId, 
      String? longitude, 
      String? latitude, 
      String? visitDay,}){
    _id = id;
    _name = name;
    _category = category;
    _cityId = cityId;
    _longitude = longitude;
    _latitude = latitude;
    _visitDay = visitDay;
}

  Outlet.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _category = json['category'];
    _cityId = json['city_id'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _visitDay = json['visit_day'];
  }
  String? _id;
  String? _name;
  String? _category;
  String? _cityId;
  String? _longitude;
  String? _latitude;
  String? _visitDay;
Outlet copyWith({  String? id,
  String? name,
  String? category,
  String? cityId,
  String? longitude,
  String? latitude,
  String? visitDay,
}) => Outlet(  id: id ?? _id,
  name: name ?? _name,
  category: category ?? _category,
  cityId: cityId ?? _cityId,
  longitude: longitude ?? _longitude,
  latitude: latitude ?? _latitude,
  visitDay: visitDay ?? _visitDay,
);
  String? get id => _id;
  String? get name => _name;
  String? get category => _category;
  String? get cityId => _cityId;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  String? get visitDay => _visitDay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['category'] = _category;
    map['city_id'] = _cityId;
    map['longitude'] = _longitude;
    map['latitude'] = _latitude;
    map['visit_day'] = _visitDay;
    return map;
  }

}