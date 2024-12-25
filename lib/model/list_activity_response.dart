
class ListActivityResponse {
  String? status;
  String? message;
  List<Data>? data;

  ListActivityResponse({this.status, this.message, this.data});

  ListActivityResponse.fromJson(Map<String, dynamic> json) {
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

  static List<ListActivityResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(ListActivityResponse.fromJson).toList();
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
  Outlet? outlet;
  User? user;
  Channel? channel;
  List<Av3mProducts>? av3mProducts;
  String? checkedIn;
  dynamic checkedOut;
  int? viewsKnowledge;
  int? timeAvailability;
  int? timeVisibility;
  int? timeKnowledge;
  int? timeSurvey;
  int? timeOrder;
  String? status;

  Data({this.id, this.outlet, this.user, this.channel, this.av3mProducts, this.checkedIn, this.checkedOut, this.viewsKnowledge, this.timeAvailability, this.timeVisibility, this.timeKnowledge, this.timeSurvey, this.timeOrder, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["outlet"] is Map) {
      outlet = json["outlet"] == null ? null : Outlet.fromJson(json["outlet"]);
    }
    if(json["user"] is Map) {
      user = json["user"] == null ? null : User.fromJson(json["user"]);
    }
    if(json["channel"] is Map) {
      channel = json["channel"] == null ? null : Channel.fromJson(json["channel"]);
    }
    if(json["av3m_products"] is List) {
      av3mProducts = json["av3m_products"] == null ? null : (json["av3m_products"] as List).map((e) => Av3mProducts.fromJson(e)).toList();
    }
    if(json["checked_in"] is String) {
      checkedIn = json["checked_in"];
    }
    checkedOut = json["checked_out"];
    if(json["views_knowledge"] is int) {
      viewsKnowledge = json["views_knowledge"];
    }
    if(json["time_availability"] is int) {
      timeAvailability = json["time_availability"];
    }
    if(json["time_visibility"] is int) {
      timeVisibility = json["time_visibility"];
    }
    if(json["time_knowledge"] is int) {
      timeKnowledge = json["time_knowledge"];
    }
    if(json["time_survey"] is int) {
      timeSurvey = json["time_survey"];
    }
    if(json["time_order"] is int) {
      timeOrder = json["time_order"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if(outlet != null) {
      _data["outlet"] = outlet?.toJson();
    }
    if(user != null) {
      _data["user"] = user?.toJson();
    }
    if(channel != null) {
      _data["channel"] = channel?.toJson();
    }
    if(av3mProducts != null) {
      _data["av3m_products"] = av3mProducts?.map((e) => e.toJson()).toList();
    }
    _data["checked_in"] = checkedIn;
    _data["checked_out"] = checkedOut;
    _data["views_knowledge"] = viewsKnowledge;
    _data["time_availability"] = timeAvailability;
    _data["time_visibility"] = timeVisibility;
    _data["time_knowledge"] = timeKnowledge;
    _data["time_survey"] = timeSurvey;
    _data["time_order"] = timeOrder;
    _data["status"] = status;
    return _data;
  }
}

class Av3mProducts {
  String? productId;
  int? av3M;

  Av3mProducts({this.productId, this.av3M});

  Av3mProducts.fromJson(Map<String, dynamic> json) {
    if(json["product_id"] is String) {
      productId = json["product_id"];
    }
    if(json["av3m"] is int) {
      av3M = json["av3m"];
    }
  }

  static List<Av3mProducts> fromList(List<Map<String, dynamic>> list) {
    return list.map(Av3mProducts.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["product_id"] = productId;
    _data["av3m"] = av3M;
    return _data;
  }
}

class Channel {
  String? id;
  String? name;

  Channel({this.id, this.name});

  Channel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  static List<Channel> fromList(List<Map<String, dynamic>> list) {
    return list.map(Channel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}

class User {
  String? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
  }

  static List<User> fromList(List<Map<String, dynamic>> list) {
    return list.map(User.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}

class Outlet {
  String? id;
  String? name;
  String? category;
  String? cityId;
  String? longitude;
  String? latitude;
  String? visitDay;

  Outlet({this.id, this.name, this.category, this.cityId, this.longitude, this.latitude, this.visitDay});

  Outlet.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["category"] is String) {
      category = json["category"];
    }
    if(json["city_id"] is String) {
      cityId = json["city_id"];
    }
    if(json["longitude"] is String) {
      longitude = json["longitude"];
    }
    if(json["latitude"] is String) {
      latitude = json["latitude"];
    }
    if(json["visit_day"] is String) {
      visitDay = json["visit_day"];
    }
  }

  static List<Outlet> fromList(List<Map<String, dynamic>> list) {
    return list.map(Outlet.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["category"] = category;
    _data["city_id"] = cityId;
    _data["longitude"] = longitude;
    _data["latitude"] = latitude;
    _data["visit_day"] = visitDay;
    return _data;
  }
}