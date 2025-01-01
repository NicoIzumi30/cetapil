
class ListKnowledgeResponse {
  String? status;
  String? message;
  List<Data>? data;

  ListKnowledgeResponse({this.status, this.message, this.data});

  ListKnowledgeResponse.fromJson(Map<String, dynamic> json) {
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

  static List<ListKnowledgeResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(ListKnowledgeResponse.fromJson).toList();
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
  String? pathPdf;
  String? pathVideo;

  Data({this.id, this.pathPdf, this.pathVideo});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["path_pdf"] is String) {
      pathPdf = json["path_pdf"];
    }
    if(json["path_video"] is String) {
      pathVideo = json["path_video"];
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["path_pdf"] = pathPdf;
    _data["path_video"] = pathVideo;
    return _data;
  }
}