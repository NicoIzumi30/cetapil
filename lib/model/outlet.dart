class OutletResponse {
  String? status;
  String? message;
  List<Outlet>? data;

  OutletResponse({this.status, this.message, this.data});

  OutletResponse.fromJson(Map<String, dynamic> json) {
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List).map((e) => Outlet.fromJson(e)).toList();
    }
  }

  static List<OutletResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(OutletResponse.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Outlet {
  String? id;
  User? user;
  String? name;
  String? category;
  Channel? channel; // Changed from String to Channel? type
  String? visitDay;
  String? longitude;
  String? latitude;
  City? city;
  String? address;
  String? status;
  dynamic weekType;
  String? cycle;
  dynamic salesActivity;
  List<Images>? images;
  List<Forms>? forms;
  String? dataSource;
  bool? isSynced;

  Outlet({
    this.id,
    this.user,
    this.name,
    this.category,
    this.channel, // Updated parameter
    this.visitDay,
    this.longitude,
    this.latitude,
    this.city,
    this.address,
    this.status,
    this.weekType,
    this.cycle,
    this.salesActivity,
    this.images,
    this.forms,
    this.dataSource = 'API',
    this.isSynced = true,
  });

  Outlet.fromJson(Map<String, dynamic> json) {
    id = json["id"] as String?;
    user = json["user"] == null ? null : User.fromJson(json["user"] as Map<String, dynamic>);
    name = json["name"] as String?;
    category = json["category"] as String?;
    channel = json["channel"] == null
        ? null
        : Channel.fromJson(json["channel"] as Map<String, dynamic>); // Parse channel
    visitDay = json["visit_day"] as String?;
    longitude = json["longitude"] as String?;
    latitude = json["latitude"] as String?;
    city = json["city"] == null ? null : City.fromJson(json["city"] as Map<String, dynamic>);
    address = json["address"] as String?;
    status = json["status"] as String?;
    weekType = json["week_type"];
    cycle = json["cycle"] as String?;
    salesActivity = json["sales_activity"];
    images =
        (json["images"] as List?)?.map((e) => Images.fromJson(e as Map<String, dynamic>)).toList();
    forms =
        (json["forms"] as List?)?.map((e) => Forms.fromJson(e as Map<String, dynamic>)).toList();
    dataSource = json["data_source"] as String? ?? 'API';
    isSynced = json["is_synced"] as bool? ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (user != null) {
      _data["user"] = user?.toJson();
    }
    _data["name"] = name;
    _data["category"] = category;
    if (channel != null) {
      _data["channel"] = channel?.toJson(); // Convert channel to JSON
    }
    _data["visit_day"] = visitDay;
    _data["longitude"] = longitude;
    _data["latitude"] = latitude;
    if (city != null) {
      _data["city"] = city?.toJson();
    }
    _data["address"] = address;
    _data["status"] = status;
    _data["week_type"] = weekType;
    _data["cycle"] = cycle;
    _data["sales_activity"] = salesActivity;
    if (images != null) {
      _data["images"] = images?.map((e) => e.toJson()).toList();
    }
    if (forms != null) {
      _data["forms"] = forms?.map((e) => e.toJson()).toList();
    }
    _data["data_source"] = dataSource;
    _data["is_synced"] = isSynced;
    return _data;
  }
}

class Channel {
  String? id;
  String? name;

  Channel({this.id, this.name});

  Channel.fromJson(Map<String, dynamic> json) {
    id = json["id"] as String?;
    name = json["name"] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}

class Forms {
  String? id;
  OutletForm? outletForm;
  String? answer;

  Forms({this.id, this.outletForm, this.answer});

  Forms.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["outletForm"] is Map) {
      outletForm = json["outletForm"] == null ? null : OutletForm.fromJson(json["outletForm"]);
    }
    if (json["answer"] is String) {
      answer = json["answer"];
    }
  }

  static List<Forms> fromList(List<Map<String, dynamic>> list) {
    return list.map(Forms.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    if (outletForm != null) {
      _data["outletForm"] = outletForm?.toJson();
    }
    _data["answer"] = answer;
    return _data;
  }
}

class OutletForm {
  String? id;
  String? type;
  String? question;

  OutletForm({this.id, this.type, this.question});

  OutletForm.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["type"] is String) {
      type = json["type"];
    }
    if (json["question"] is String) {
      question = json["question"];
    }
  }

  static List<OutletForm> fromList(List<Map<String, dynamic>> list) {
    return list.map(OutletForm.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["type"] = type;
    _data["question"] = question;
    return _data;
  }
}

class Images {
  String? id;
  int? position;
  String? filename;
  String? image;

  Images({this.id, this.position, this.filename, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["position"] is int) {
      position = json["position"];
    }
    if (json["filename"] is String) {
      filename = json["filename"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
  }

  static List<Images> fromList(List<Map<String, dynamic>> list) {
    return list.map(Images.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["position"] = position;
    _data["filename"] = filename;
    _data["image"] = image;
    return _data;
  }
}

class City {
  String? id;
  String? name;

  City({this.id, this.name});

  City.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
  }

  static List<City> fromList(List<Map<String, dynamic>> list) {
    return list.map(City.fromJson).toList();
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
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["name"] is String) {
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
