class Dashboard {
  String? status;
  String? message;
  Data? data;

  Dashboard({this.status, this.message, this.data});

  Dashboard.fromJson(Map<String, dynamic> json) {
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["data"] is Map) {
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
    if (data != null) {
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
  List<PowerSkus>? powerSkus;
  List<Programs>? programs; // Add this line
  String? lastPerformanceUpdate;
  String? lastPowerSkuUpdate;

  Data(
      {this.city,
      this.region,
      this.role,
      this.totalOutlet,
      this.totalActualPlan,
      this.totalCallPlan,
      this.planPercentage,
      this.currentOutlet,
      this.powerSkus,
      this.programs, // Add this line
      this.lastPerformanceUpdate,
      this.lastPowerSkuUpdate});

  Data.fromJson(Map<String, dynamic> json) {
    city = json["city"];
    region = json["region"];
    if (json["role"] is String) {
      role = json["role"];
    }
    if (json["total_outlet"] is int) {
      totalOutlet = json["total_outlet"];
    }
    if (json["total_actual_plan"] is int) {
      totalActualPlan = json["total_actual_plan"];
    }
    if (json["total_call_plan"] is int) {
      totalCallPlan = json["total_call_plan"];
    }
    if (json["plan_percentage"] is int) {
      planPercentage = json["plan_percentage"];
    }
    if (json["current_outlet"] is Map) {
      currentOutlet =
          json["current_outlet"] == null ? null : CurrentOutlet.fromJson(json["current_outlet"]);
    }
    if (json["power_skus"] is List) {
      powerSkus = json["power_skus"] == null
          ? null
          : (json["power_skus"] as List).map((e) => PowerSkus.fromJson(e)).toList();
    }
    // Add this block
    if (json["programs"] is List) {
      programs = json["programs"] == null
          ? null
          : (json["programs"] as List).map((e) => Programs.fromJson(e)).toList();
    }
    if (json["last_performance_update"] is String) {
      lastPerformanceUpdate = json["last_performance_update"];
    }
    if (json["last_power_sku_update"] is String) {
      lastPowerSkuUpdate = json["last_power_sku_update"];
    }
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
    if (currentOutlet != null) {
      _data["current_outlet"] = currentOutlet?.toJson();
    }
    if (powerSkus != null) {
      _data["power_skus"] = powerSkus?.map((e) => e.toJson()).toList();
    }
    // Add this block
    if (programs != null) {
      _data["programs"] = programs?.map((e) => e.toJson()).toList();
    }
    _data["last_performance_update"] = lastPerformanceUpdate;
    _data["last_power_sku_update"] = lastPowerSkuUpdate;
    return _data;
  }
}

class PowerSkus {
  String? sku;
  int? totalOutlets;
  int? availableCount;
  double? availabilityPercentage;

  PowerSkus({this.sku, this.totalOutlets, this.availableCount, this.availabilityPercentage});

  PowerSkus.fromJson(Map<String, dynamic> json) {
    if (json["sku"] is String) {
      sku = json["sku"];
    }
    if (json["total_outlets"] is int) {
      totalOutlets = json["total_outlets"];
    }
    if (json["available_count"] is int) {
      availableCount = json["available_count"];
    }
    if (json["availability_percentage"] is num) {
      availabilityPercentage = (json["availability_percentage"] as num).toDouble();
    }
  }

  static List<PowerSkus> fromList(List<Map<String, dynamic>> list) {
    return list.map(PowerSkus.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["sku"] = sku;
    _data["total_outlets"] = totalOutlets;
    _data["available_count"] = availableCount;
    _data["availability_percentage"] = availabilityPercentage;
    return _data;
  }
}

class CurrentOutlet {
  dynamic outletId;
  dynamic salesActivityId;
  String? name;
  dynamic checkedIn;
  dynamic checkedOut;
  String? outletLatitude;
  String? outletLongitude;
  String? checkInLatitude;
  String? checkInLongitude;
  String? radius;
  double? distanceToOutlet;

  CurrentOutlet(
      {this.outletId,
      this.salesActivityId,
      this.name,
      this.checkedIn,
      this.checkedOut,
      this.outletLatitude,
      this.outletLongitude,
      this.checkInLatitude,
      this.checkInLongitude,
      this.radius,
      this.distanceToOutlet});

  CurrentOutlet.fromJson(Map<String, dynamic> json) {
    if (json["outlet_id"] is String) {
      outletId = json["outlet_id"];
    }
    if (json["sales_activity_id"] is String) {
      salesActivityId = json["sales_activity_id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["checked_in"] is String) {
      checkedIn = json["checked_in"];
    }
    checkedOut = json["checked_out"];
    if (json["outlet_latitude"] is String) {
      outletLatitude = json["outlet_latitude"];
    }
    if (json["outlet_longitude"] is String) {
      outletLongitude = json["outlet_longitude"];
    }
    if (json["check_in_latitude"] is String) {
      checkInLatitude = json["check_in_latitude"];
    }
    if (json["check_in_longitude"] is String) {
      checkInLongitude = json["check_in_longitude"];
    }
    if (json["radius"] is String) {
      radius = json["radius"];
    }
    if (json["distance_to_outlet"] is double) {
      distanceToOutlet = json["distance_to_outlet"];
    }
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
    _data["outlet_latitude"] = outletLatitude;
    _data["outlet_longitude"] = outletLongitude;
    _data["check_in_latitude"] = checkInLatitude;
    _data["check_in_longitude"] = checkInLongitude;
    _data["radius"] = radius;
    _data["distance_to_outlet"] = distanceToOutlet;
    return _data;
  }
}

class Programs {
  dynamic id;
  String? provinceCode;
  String? filename;
  String? path;

  Programs({this.id, this.provinceCode, this.filename, this.path});

  Programs.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["province_code"] is String) {
      provinceCode = json["province_code"];
    }
    if (json["filename"] is String) {
      filename = json["filename"];
    }
    if (json["path"] is String) {
      path = json["path"];
    }
  }

  static List<Programs> fromList(List<Map<String, dynamic>> list) {
    return list.map(Programs.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["province_code"] = provinceCode;
    _data["filename"] = filename;
    _data["path"] = path;
    return _data;
  }
}
