
class CalendarResponse {
  String? status;
  String? message;
  Data? data;

  CalendarResponse({this.status, this.message, this.data});

  CalendarResponse.fromJson(Map<String, dynamic> json) {
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
  }

  static List<CalendarResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(CalendarResponse.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  int? month;
  int? year;
  int? totalDays;
  List<CalendarData>? calendarData;

  Data({this.month, this.year, this.totalDays, this.calendarData});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["month"] is int) {
      month = json["month"];
    }
    if(json["year"] is int) {
      year = json["year"];
    }
    if(json["total_days"] is int) {
      totalDays = json["total_days"];
    }
    if(json["calendar_data"] is List) {
      calendarData = json["calendar_data"] == null ? null : (json["calendar_data"] as List).map((e) => CalendarData.fromJson(e)).toList();
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["month"] = month;
    _data["year"] = year;
    _data["total_days"] = totalDays;
    if(calendarData != null) {
      _data["calendar_data"] = calendarData?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class CalendarData {
  String? date;
  int? day;
  Activities? activities;
  bool? hasAnyActivity;

  CalendarData({this.date, this.day, this.activities, this.hasAnyActivity});

  CalendarData.fromJson(Map<String, dynamic> json) {
    if(json["date"] is String) {
      date = json["date"];
    }
    if(json["day"] is int) {
      day = json["day"];
    }
    if(json["activities"] is Map) {
      activities = json["activities"] == null ? null : Activities.fromJson(json["activities"]);
    }
    if(json["has_any_activity"] is bool) {
      hasAnyActivity = json["has_any_activity"];
    }
  }

  static List<CalendarData> fromList(List<Map<String, dynamic>> list) {
    return list.map(CalendarData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["date"] = date;
    _data["day"] = day;
    if(activities != null) {
      _data["activities"] = activities?.toJson();
    }
    _data["has_any_activity"] = hasAnyActivity;
    return _data;
  }
}

class Activities {
  Sales? sales;
  Outlets? outlets;
  Selling? selling;

  Activities({this.sales, this.outlets, this.selling});

  Activities.fromJson(Map<String, dynamic> json) {
    if(json["sales"] is Map) {
      sales = json["sales"] == null ? null : Sales.fromJson(json["sales"]);
    }
    if(json["outlets"] is Map) {
      outlets = json["outlets"] == null ? null : Outlets.fromJson(json["outlets"]);
    }
    if(json["selling"] is Map) {
      selling = json["selling"] == null ? null : Selling.fromJson(json["selling"]);
    }
  }

  static List<Activities> fromList(List<Map<String, dynamic>> list) {
    return list.map(Activities.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if(sales != null) {
      _data["sales"] = sales?.toJson();
    }
    if(outlets != null) {
      _data["outlets"] = outlets?.toJson();
    }
    if(selling != null) {
      _data["selling"] = selling?.toJson();
    }
    return _data;
  }
}

class Selling {
  bool? hasActivity;
  int? total;

  Selling({this.hasActivity, this.total});

  Selling.fromJson(Map<String, dynamic> json) {
    if(json["has_activity"] is bool) {
      hasActivity = json["has_activity"];
    }
    if(json["total"] is int) {
      total = json["total"];
    }
  }

  static List<Selling> fromList(List<Map<String, dynamic>> list) {
    return list.map(Selling.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["has_activity"] = hasActivity;
    _data["total"] = total;
    return _data;
  }
}

class Outlets {
  bool? hasActivity;
  int? total;

  Outlets({this.hasActivity, this.total});

  Outlets.fromJson(Map<String, dynamic> json) {
    if(json["has_activity"] is bool) {
      hasActivity = json["has_activity"];
    }
    if(json["total"] is int) {
      total = json["total"];
    }
  }

  static List<Outlets> fromList(List<Map<String, dynamic>> list) {
    return list.map(Outlets.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["has_activity"] = hasActivity;
    _data["total"] = total;
    return _data;
  }
}

class Sales {
  bool? hasActivity;
  int? total;

  Sales({this.hasActivity, this.total});

  Sales.fromJson(Map<String, dynamic> json) {
    if(json["has_activity"] is bool) {
      hasActivity = json["has_activity"];
    }
    if(json["total"] is int) {
      total = json["total"];
    }
  }

  static List<Sales> fromList(List<Map<String, dynamic>> list) {
    return list.map(Sales.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["has_activity"] = hasActivity;
    _data["total"] = total;
    return _data;
  }
}