
class Dashboard {
  String? status;
  String? message;
  Data? data;

  Dashboard({this.status, this.message, this.data});

  Dashboard.fromJson(Map<String, dynamic> json) {
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

  static List<Dashboard> fromList(List<Map<String, dynamic>> list) {
    return list.map(Dashboard.fromJson).toList();
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
  dynamic city;
  dynamic region;
  String? role;
  int? totalOutlet;
  int? totalActualPlan;
  int? totalCallPlan;
  int? planPercentage;
  CurrentOutlet? currentOutlet;

  Data({this.city, this.region, this.role, this.totalOutlet, this.totalActualPlan, this.totalCallPlan, this.planPercentage, this.currentOutlet});

  Data.fromJson(Map<String, dynamic> json) {
    city = json["city"];
    region = json["region"];
    if(json["role"] is String) {
      role = json["role"];
    }
    if(json["total_outlet"] is int) {
      totalOutlet = json["total_outlet"];
    }
    if(json["total_actual_plan"] is int) {
      totalActualPlan = json["total_actual_plan"];
    }
    if(json["total_call_plan"] is int) {
      totalCallPlan = json["total_call_plan"];
    }
    if(json["plan_percentage"] is int) {
      planPercentage = json["plan_percentage"];
    }
    if(json["current_outlet"] is Map) {
      currentOutlet = json["current_outlet"] == null ? null : CurrentOutlet.fromJson(json["current_outlet"]);
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["city"] = city;
    _data["region"] = region;
    _data["role"] = role;
    _data["total_outlet"] = totalOutlet;
    _data["total_actual_plan"] = totalActualPlan;
    _data["total_call_plan"] = totalCallPlan;
    _data["plan_percentage"] = planPercentage;
    if(currentOutlet != null) {
      _data["current_outlet"] = currentOutlet?.toJson();
    }
    return _data;
  }
}

class CurrentOutlet {
  dynamic outletId;
  dynamic salesActivityId;
  String? name;
  dynamic checkedIn;
  dynamic checkedOut;

  CurrentOutlet({this.outletId, this.salesActivityId, this.name, this.checkedIn, this.checkedOut});

  CurrentOutlet.fromJson(Map<String, dynamic> json) {
    outletId = json["outlet_id"];
    salesActivityId = json["sales_activity_id"];
    if(json["name"] is String) {
      name = json["name"];
    }
    checkedIn = json["checked_in"];
    checkedOut = json["checked_out"];
  }

  static List<CurrentOutlet> fromList(List<Map<String, dynamic>> list) {
    return list.map(CurrentOutlet.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["outlet_id"] = outletId;
    _data["sales_activity_id"] = salesActivityId;
    _data["name"] = name;
    _data["checked_in"] = checkedIn;
    _data["checked_out"] = checkedOut;
    return _data;
  }
}