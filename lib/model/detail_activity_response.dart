/// data : {"id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","outlet_id":"9d944733-79a9-4f18-949d-119cdf6bd5d0","user_id":"9da8fe31-5e66-4973-bb02-b737520147dd","views_knowledge":111,"time_availability":213,"time_visibility":1227,"time_knowledge":6,"time_survey":59,"time_order":20,"checked_in":"2024-12-06 19:37:34","checked_out":"2024-12-06 22:32:07","status":"IN_PROGRESS","channel":{"id":"9da8fe45-ce0d-4a15-b6de-e8d6905cdc26","name":"Minimarket"},"outlet":{"id":"9d944733-79a9-4f18-949d-119cdf6bd5d0","name":"Outlet 23","category":"mt","visit_day":"2"},"orders":[{"id":"9da72447-ebc9-4f25-a661-bb094f06bf3b","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","product_id":"9d783acb-1110-4e13-ba9a-43974e89f247","total_items":50,"subtotal":50}],"visibilities":[{"id":"9da72447-dc7d-458f-8fd1-2445c61ef365","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","visibility_id":"9da922c4-aad4-45ab-855f-f86c7ca4569b","path1":"/images/sales-visibility/9da72447-dc7d-458f-8fd1-2445c61ef365/file1/compressed_1733411315069_1733411937.jpg","path2":"/images/sales-visibility/9da72447-dc7d-458f-8fd1-2445c61ef365/file2/compressed_1733411320926_1733411937.jpg","condition":"GOOD"}],"availabilities":[{"id":"9da72447-d7c0-41b7-900a-d20b500e6c16","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","product_id":"9daae045-ea6e-4e05-93b2-0bb0801192d4","availability_stock":600,"average_stock":3,"ideal_stock":600}],"surveys":[{"id":"9da72447-e634-48c9-90df-28c428c102ee","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-0deb-40be-9f37-0e304d703d1f","answer":"false"},{"id":"9da72447-e6dd-48eb-aa08-5e774354b33b","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-1105-4e9b-b9bc-15db25baa6b9","answer":"true"},{"id":"9da72447-e76c-497b-b13a-fd1442d16c54","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-132f-41aa-b8cb-6cebc76dbf43","answer":"false"},{"id":"9da72447-e902-417e-b58c-3c0a042e51c6","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-1534-4dea-9572-74063de72bcd","answer":"true"},{"id":"9da72447-e959-4b0d-8944-fcc1f89517bf","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-176b-49ae-a572-b6008f037581","answer":"false"},{"id":"9da72447-e99c-45b4-896b-b09b60b252bc","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-1918-40f5-ba93-6a09506ae984","answer":"true"},{"id":"9da72447-e9d8-43cd-bdcb-312d31eb19d7","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3413-490a-9272-1d0d59eb055d","answer":"false"},{"id":"9da72447-ea0e-41a6-896b-2310ee638091","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3764-428f-8d70-0c1e13566e36","answer":"true"},{"id":"9da72447-ea4a-490a-8b58-dc4eee59352b","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-397e-4251-a7b0-b6f15afb8018","answer":"false"},{"id":"9da72447-ea81-4aca-95c8-4d360b2236e4","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3b85-4982-93e5-4094224cdfc8","answer":"true"},{"id":"9da72447-eabd-42b8-ac7e-636db644a064","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3d96-4fb3-bf6c-e538eab1d9d3","answer":"false"},{"id":"9da72447-eafd-4a56-9d31-3ab3b5a1bd75","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3f67-4eae-a266-34cb4b5b7c82","answer":"true"},{"id":"9da72447-eb44-49f7-92c6-ebff1d2e15b2","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-414f-4935-b715-e2c89fb9d4ec","answer":"false"},{"id":"9da72447-eb80-4357-8bc3-692e3f41d78d","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9da8fe3f-8f7b-4f71-9b70-0c41f65f3a42","answer":"true"}]}

class DetailActivityResponse {
  DetailActivityResponse({
      Data? data,}){
    _data = data;
}

  DetailActivityResponse.fromJson(dynamic json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Data? _data;
DetailActivityResponse copyWith({  Data? data,
}) => DetailActivityResponse(  data: data ?? _data,
);
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// id : "9da4e795-e17d-4a19-98ec-11f8a3a648fd"
/// outlet_id : "9d944733-79a9-4f18-949d-119cdf6bd5d0"
/// user_id : "9da8fe31-5e66-4973-bb02-b737520147dd"
/// views_knowledge : 111
/// time_availability : 213
/// time_visibility : 1227
/// time_knowledge : 6
/// time_survey : 59
/// time_order : 20
/// checked_in : "2024-12-06 19:37:34"
/// checked_out : "2024-12-06 22:32:07"
/// status : "IN_PROGRESS"
/// channel : {"id":"9da8fe45-ce0d-4a15-b6de-e8d6905cdc26","name":"Minimarket"}
/// outlet : {"id":"9d944733-79a9-4f18-949d-119cdf6bd5d0","name":"Outlet 23","category":"mt","visit_day":"2"}
/// orders : [{"id":"9da72447-ebc9-4f25-a661-bb094f06bf3b","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","product_id":"9d783acb-1110-4e13-ba9a-43974e89f247","total_items":50,"subtotal":50}]
/// visibilities : [{"id":"9da72447-dc7d-458f-8fd1-2445c61ef365","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","visibility_id":"9da922c4-aad4-45ab-855f-f86c7ca4569b","path1":"/images/sales-visibility/9da72447-dc7d-458f-8fd1-2445c61ef365/file1/compressed_1733411315069_1733411937.jpg","path2":"/images/sales-visibility/9da72447-dc7d-458f-8fd1-2445c61ef365/file2/compressed_1733411320926_1733411937.jpg","condition":"GOOD"}]
/// availabilities : [{"id":"9da72447-d7c0-41b7-900a-d20b500e6c16","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","product_id":"9daae045-ea6e-4e05-93b2-0bb0801192d4","availability_stock":600,"average_stock":3,"ideal_stock":600}]
/// surveys : [{"id":"9da72447-e634-48c9-90df-28c428c102ee","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-0deb-40be-9f37-0e304d703d1f","answer":"false"},{"id":"9da72447-e6dd-48eb-aa08-5e774354b33b","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-1105-4e9b-b9bc-15db25baa6b9","answer":"true"},{"id":"9da72447-e76c-497b-b13a-fd1442d16c54","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-132f-41aa-b8cb-6cebc76dbf43","answer":"false"},{"id":"9da72447-e902-417e-b58c-3c0a042e51c6","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-1534-4dea-9572-74063de72bcd","answer":"true"},{"id":"9da72447-e959-4b0d-8944-fcc1f89517bf","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-176b-49ae-a572-b6008f037581","answer":"false"},{"id":"9da72447-e99c-45b4-896b-b09b60b252bc","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-1918-40f5-ba93-6a09506ae984","answer":"true"},{"id":"9da72447-e9d8-43cd-bdcb-312d31eb19d7","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3413-490a-9272-1d0d59eb055d","answer":"false"},{"id":"9da72447-ea0e-41a6-896b-2310ee638091","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3764-428f-8d70-0c1e13566e36","answer":"true"},{"id":"9da72447-ea4a-490a-8b58-dc4eee59352b","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-397e-4251-a7b0-b6f15afb8018","answer":"false"},{"id":"9da72447-ea81-4aca-95c8-4d360b2236e4","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3b85-4982-93e5-4094224cdfc8","answer":"true"},{"id":"9da72447-eabd-42b8-ac7e-636db644a064","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3d96-4fb3-bf6c-e538eab1d9d3","answer":"false"},{"id":"9da72447-eafd-4a56-9d31-3ab3b5a1bd75","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-3f67-4eae-a266-34cb4b5b7c82","answer":"true"},{"id":"9da72447-eb44-49f7-92c6-ebff1d2e15b2","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9d783acc-414f-4935-b715-e2c89fb9d4ec","answer":"false"},{"id":"9da72447-eb80-4357-8bc3-692e3f41d78d","sales_activity_id":"9da4e795-e17d-4a19-98ec-11f8a3a648fd","survey_question_id":"9da8fe3f-8f7b-4f71-9b70-0c41f65f3a42","answer":"true"}]

class Data {
  Data({
      String? id, 
      String? outletId, 
      String? userId, 
      num? viewsKnowledge, 
      num? timeAvailability, 
      num? timeVisibility, 
      num? timeKnowledge, 
      num? timeSurvey, 
      num? timeOrder, 
      String? checkedIn, 
      String? checkedOut, 
      String? status, 
      Channel? channel, 
      Outlet? outlet, 
      List<Orders>? orders, 
      List<Visibilities>? visibilities, 
      List<Availabilities>? availabilities, 
      List<Surveys>? surveys,}){
    _id = id;
    _outletId = outletId;
    _userId = userId;
    _viewsKnowledge = viewsKnowledge;
    _timeAvailability = timeAvailability;
    _timeVisibility = timeVisibility;
    _timeKnowledge = timeKnowledge;
    _timeSurvey = timeSurvey;
    _timeOrder = timeOrder;
    _checkedIn = checkedIn;
    _checkedOut = checkedOut;
    _status = status;
    _channel = channel;
    _outlet = outlet;
    _orders = orders;
    _visibilities = visibilities;
    _availabilities = availabilities;
    _surveys = surveys;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _outletId = json['outlet_id'];
    _userId = json['user_id'];
    _viewsKnowledge = json['views_knowledge'];
    _timeAvailability = json['time_availability'];
    _timeVisibility = json['time_visibility'];
    _timeKnowledge = json['time_knowledge'];
    _timeSurvey = json['time_survey'];
    _timeOrder = json['time_order'];
    _checkedIn = json['checked_in'];
    _checkedOut = json['checked_out'];
    _status = json['status'];
    _channel = json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    _outlet = json['outlet'] != null ? Outlet.fromJson(json['outlet']) : null;
    if (json['orders'] != null) {
      _orders = [];
      json['orders'].forEach((v) {
        _orders?.add(Orders.fromJson(v));
      });
    }
    if (json['visibilities'] != null) {
      _visibilities = [];
      json['visibilities'].forEach((v) {
        _visibilities?.add(Visibilities.fromJson(v));
      });
    }
    if (json['availabilities'] != null) {
      _availabilities = [];
      json['availabilities'].forEach((v) {
        _availabilities?.add(Availabilities.fromJson(v));
      });
    }
    if (json['surveys'] != null) {
      _surveys = [];
      json['surveys'].forEach((v) {
        _surveys?.add(Surveys.fromJson(v));
      });
    }
  }
  String? _id;
  String? _outletId;
  String? _userId;
  num? _viewsKnowledge;
  num? _timeAvailability;
  num? _timeVisibility;
  num? _timeKnowledge;
  num? _timeSurvey;
  num? _timeOrder;
  String? _checkedIn;
  String? _checkedOut;
  String? _status;
  Channel? _channel;
  Outlet? _outlet;
  List<Orders>? _orders;
  List<Visibilities>? _visibilities;
  List<Availabilities>? _availabilities;
  List<Surveys>? _surveys;
Data copyWith({  String? id,
  String? outletId,
  String? userId,
  num? viewsKnowledge,
  num? timeAvailability,
  num? timeVisibility,
  num? timeKnowledge,
  num? timeSurvey,
  num? timeOrder,
  String? checkedIn,
  String? checkedOut,
  String? status,
  Channel? channel,
  Outlet? outlet,
  List<Orders>? orders,
  List<Visibilities>? visibilities,
  List<Availabilities>? availabilities,
  List<Surveys>? surveys,
}) => Data(  id: id ?? _id,
  outletId: outletId ?? _outletId,
  userId: userId ?? _userId,
  viewsKnowledge: viewsKnowledge ?? _viewsKnowledge,
  timeAvailability: timeAvailability ?? _timeAvailability,
  timeVisibility: timeVisibility ?? _timeVisibility,
  timeKnowledge: timeKnowledge ?? _timeKnowledge,
  timeSurvey: timeSurvey ?? _timeSurvey,
  timeOrder: timeOrder ?? _timeOrder,
  checkedIn: checkedIn ?? _checkedIn,
  checkedOut: checkedOut ?? _checkedOut,
  status: status ?? _status,
  channel: channel ?? _channel,
  outlet: outlet ?? _outlet,
  orders: orders ?? _orders,
  visibilities: visibilities ?? _visibilities,
  availabilities: availabilities ?? _availabilities,
  surveys: surveys ?? _surveys,
);
  String? get id => _id;
  String? get outletId => _outletId;
  String? get userId => _userId;
  num? get viewsKnowledge => _viewsKnowledge;
  num? get timeAvailability => _timeAvailability;
  num? get timeVisibility => _timeVisibility;
  num? get timeKnowledge => _timeKnowledge;
  num? get timeSurvey => _timeSurvey;
  num? get timeOrder => _timeOrder;
  String? get checkedIn => _checkedIn;
  String? get checkedOut => _checkedOut;
  String? get status => _status;
  Channel? get channel => _channel;
  Outlet? get outlet => _outlet;
  List<Orders>? get orders => _orders;
  List<Visibilities>? get visibilities => _visibilities;
  List<Availabilities>? get availabilities => _availabilities;
  List<Surveys>? get surveys => _surveys;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['outlet_id'] = _outletId;
    map['user_id'] = _userId;
    map['views_knowledge'] = _viewsKnowledge;
    map['time_availability'] = _timeAvailability;
    map['time_visibility'] = _timeVisibility;
    map['time_knowledge'] = _timeKnowledge;
    map['time_survey'] = _timeSurvey;
    map['time_order'] = _timeOrder;
    map['checked_in'] = _checkedIn;
    map['checked_out'] = _checkedOut;
    map['status'] = _status;
    if (_channel != null) {
      map['channel'] = _channel?.toJson();
    }
    if (_outlet != null) {
      map['outlet'] = _outlet?.toJson();
    }
    if (_orders != null) {
      map['orders'] = _orders?.map((v) => v.toJson()).toList();
    }
    if (_visibilities != null) {
      map['visibilities'] = _visibilities?.map((v) => v.toJson()).toList();
    }
    if (_availabilities != null) {
      map['availabilities'] = _availabilities?.map((v) => v.toJson()).toList();
    }
    if (_surveys != null) {
      map['surveys'] = _surveys?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "9da72447-e634-48c9-90df-28c428c102ee"
/// sales_activity_id : "9da4e795-e17d-4a19-98ec-11f8a3a648fd"
/// survey_question_id : "9d783acc-0deb-40be-9f37-0e304d703d1f"
/// answer : "false"

class Surveys {
  Surveys({
      String? id, 
      String? salesActivityId, 
      String? surveyQuestionId, 
      String? answer,}){
    _id = id;
    _salesActivityId = salesActivityId;
    _surveyQuestionId = surveyQuestionId;
    _answer = answer;
}

  Surveys.fromJson(dynamic json) {
    _id = json['id'];
    _salesActivityId = json['sales_activity_id'];
    _surveyQuestionId = json['survey_question_id'];
    _answer = json['answer'];
  }
  String? _id;
  String? _salesActivityId;
  String? _surveyQuestionId;
  String? _answer;
Surveys copyWith({  String? id,
  String? salesActivityId,
  String? surveyQuestionId,
  String? answer,
}) => Surveys(  id: id ?? _id,
  salesActivityId: salesActivityId ?? _salesActivityId,
  surveyQuestionId: surveyQuestionId ?? _surveyQuestionId,
  answer: answer ?? _answer,
);
  String? get id => _id;
  String? get salesActivityId => _salesActivityId;
  String? get surveyQuestionId => _surveyQuestionId;
  String? get answer => _answer;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sales_activity_id'] = _salesActivityId;
    map['survey_question_id'] = _surveyQuestionId;
    map['answer'] = _answer;
    return map;
  }

}

/// id : "9da72447-d7c0-41b7-900a-d20b500e6c16"
/// sales_activity_id : "9da4e795-e17d-4a19-98ec-11f8a3a648fd"
/// product_id : "9daae045-ea6e-4e05-93b2-0bb0801192d4"
/// availability_stock : 600
/// average_stock : 3
/// ideal_stock : 600

class Availabilities {
  Availabilities({
      String? id, 
      String? salesActivityId, 
      String? productId, 
      num? availabilityStock, 
      num? averageStock, 
      num? idealStock,}){
    _id = id;
    _salesActivityId = salesActivityId;
    _productId = productId;
    _availabilityStock = availabilityStock;
    _averageStock = averageStock;
    _idealStock = idealStock;
}

  Availabilities.fromJson(dynamic json) {
    _id = json['id'];
    _salesActivityId = json['sales_activity_id'];
    _productId = json['product_id'];
    _availabilityStock = json['availability_stock'];
    _averageStock = json['average_stock'];
    _idealStock = json['ideal_stock'];
  }
  String? _id;
  String? _salesActivityId;
  String? _productId;
  num? _availabilityStock;
  num? _averageStock;
  num? _idealStock;
Availabilities copyWith({  String? id,
  String? salesActivityId,
  String? productId,
  num? availabilityStock,
  num? averageStock,
  num? idealStock,
}) => Availabilities(  id: id ?? _id,
  salesActivityId: salesActivityId ?? _salesActivityId,
  productId: productId ?? _productId,
  availabilityStock: availabilityStock ?? _availabilityStock,
  averageStock: averageStock ?? _averageStock,
  idealStock: idealStock ?? _idealStock,
);
  String? get id => _id;
  String? get salesActivityId => _salesActivityId;
  String? get productId => _productId;
  num? get availabilityStock => _availabilityStock;
  num? get averageStock => _averageStock;
  num? get idealStock => _idealStock;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sales_activity_id'] = _salesActivityId;
    map['product_id'] = _productId;
    map['availability_stock'] = _availabilityStock;
    map['average_stock'] = _averageStock;
    map['ideal_stock'] = _idealStock;
    return map;
  }

}

/// id : "9da72447-dc7d-458f-8fd1-2445c61ef365"
/// sales_activity_id : "9da4e795-e17d-4a19-98ec-11f8a3a648fd"
/// visibility_id : "9da922c4-aad4-45ab-855f-f86c7ca4569b"
/// path1 : "/images/sales-visibility/9da72447-dc7d-458f-8fd1-2445c61ef365/file1/compressed_1733411315069_1733411937.jpg"
/// path2 : "/images/sales-visibility/9da72447-dc7d-458f-8fd1-2445c61ef365/file2/compressed_1733411320926_1733411937.jpg"
/// condition : "GOOD"

class Visibilities {
  Visibilities({
      String? id, 
      String? salesActivityId, 
      String? visibilityId, 
      String? path1, 
      String? path2, 
      String? condition,}){
    _id = id;
    _salesActivityId = salesActivityId;
    _visibilityId = visibilityId;
    _path1 = path1;
    _path2 = path2;
    _condition = condition;
}

  Visibilities.fromJson(dynamic json) {
    _id = json['id'];
    _salesActivityId = json['sales_activity_id'];
    _visibilityId = json['visibility_id'];
    _path1 = json['path1'];
    _path2 = json['path2'];
    _condition = json['condition'];
  }
  String? _id;
  String? _salesActivityId;
  String? _visibilityId;
  String? _path1;
  String? _path2;
  String? _condition;
Visibilities copyWith({  String? id,
  String? salesActivityId,
  String? visibilityId,
  String? path1,
  String? path2,
  String? condition,
}) => Visibilities(  id: id ?? _id,
  salesActivityId: salesActivityId ?? _salesActivityId,
  visibilityId: visibilityId ?? _visibilityId,
  path1: path1 ?? _path1,
  path2: path2 ?? _path2,
  condition: condition ?? _condition,
);
  String? get id => _id;
  String? get salesActivityId => _salesActivityId;
  String? get visibilityId => _visibilityId;
  String? get path1 => _path1;
  String? get path2 => _path2;
  String? get condition => _condition;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sales_activity_id'] = _salesActivityId;
    map['visibility_id'] = _visibilityId;
    map['path1'] = _path1;
    map['path2'] = _path2;
    map['condition'] = _condition;
    return map;
  }

}

/// id : "9da72447-ebc9-4f25-a661-bb094f06bf3b"
/// sales_activity_id : "9da4e795-e17d-4a19-98ec-11f8a3a648fd"
/// product_id : "9d783acb-1110-4e13-ba9a-43974e89f247"
/// total_items : 50
/// subtotal : 50

class Orders {
  Orders({
      String? id, 
      String? salesActivityId, 
      String? productId, 
      num? totalItems, 
      num? subtotal,}){
    _id = id;
    _salesActivityId = salesActivityId;
    _productId = productId;
    _totalItems = totalItems;
    _subtotal = subtotal;
}

  Orders.fromJson(dynamic json) {
    _id = json['id'];
    _salesActivityId = json['sales_activity_id'];
    _productId = json['product_id'];
    _totalItems = json['total_items'];
    _subtotal = json['subtotal'];
  }
  String? _id;
  String? _salesActivityId;
  String? _productId;
  num? _totalItems;
  num? _subtotal;
Orders copyWith({  String? id,
  String? salesActivityId,
  String? productId,
  num? totalItems,
  num? subtotal,
}) => Orders(  id: id ?? _id,
  salesActivityId: salesActivityId ?? _salesActivityId,
  productId: productId ?? _productId,
  totalItems: totalItems ?? _totalItems,
  subtotal: subtotal ?? _subtotal,
);
  String? get id => _id;
  String? get salesActivityId => _salesActivityId;
  String? get productId => _productId;
  num? get totalItems => _totalItems;
  num? get subtotal => _subtotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['sales_activity_id'] = _salesActivityId;
    map['product_id'] = _productId;
    map['total_items'] = _totalItems;
    map['subtotal'] = _subtotal;
    return map;
  }

}

/// id : "9d944733-79a9-4f18-949d-119cdf6bd5d0"
/// name : "Outlet 23"
/// category : "mt"
/// visit_day : "2"

class Outlet {
  Outlet({
      String? id, 
      String? name, 
      String? category, 
      String? visitDay,}){
    _id = id;
    _name = name;
    _category = category;
    _visitDay = visitDay;
}

  Outlet.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _category = json['category'];
    _visitDay = json['visit_day'];
  }
  String? _id;
  String? _name;
  String? _category;
  String? _visitDay;
Outlet copyWith({  String? id,
  String? name,
  String? category,
  String? visitDay,
}) => Outlet(  id: id ?? _id,
  name: name ?? _name,
  category: category ?? _category,
  visitDay: visitDay ?? _visitDay,
);
  String? get id => _id;
  String? get name => _name;
  String? get category => _category;
  String? get visitDay => _visitDay;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['category'] = _category;
    map['visit_day'] = _visitDay;
    return map;
  }

}

/// id : "9da8fe45-ce0d-4a15-b6de-e8d6905cdc26"
/// name : "Minimarket"

class Channel {
  Channel({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Channel.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }
  String? _id;
  String? _name;
Channel copyWith({  String? id,
  String? name,
}) => Channel(  id: id ?? _id,
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