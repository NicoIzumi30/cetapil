
class SurveyQuestionResponse {
  String? status;
  String? message;
  List<SurveyQuestion>? data;

  SurveyQuestionResponse({this.status, this.message, this.data});

  SurveyQuestionResponse.fromJson(Map<String, dynamic> json) {
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => SurveyQuestion.fromJson(e)).toList();
    }
  }

  static List<SurveyQuestionResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(SurveyQuestionResponse.fromJson).toList();
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

class SurveyQuestion {
  String? id;
  String? title;
  String? name;
  List<Surveys>? surveys;

  SurveyQuestion({this.id, this.title, this.name, this.surveys});

  SurveyQuestion.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["title"] is String) {
      title = json["title"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["surveys"] is List) {
      surveys = json["surveys"] == null ? null : (json["surveys"] as List).map((e) => Surveys.fromJson(e)).toList();
    }
  }

  static List<SurveyQuestion> fromList(List<Map<String, dynamic>> list) {
    return list.map(SurveyQuestion.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["title"] = title;
    _data["name"] = name;
    if(surveys != null) {
      _data["surveys"] = surveys?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Surveys {
  String? id;
  String? productId;
  String? type;
  String? question;

  Surveys({this.id, this.productId, this.type, this.question});

  Surveys.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["product_id"] is String) {
      productId = json["product_id"];
    }
    if(json["type"] is String) {
      type = json["type"];
    }
    if(json["question"] is String) {
      question = json["question"];
    }
  }

  static List<Surveys> fromList(List<Map<String, dynamic>> list) {
    return list.map(Surveys.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["product_id"] = productId;
    _data["type"] = type;
    _data["question"] = question;
    return _data;
  }
}