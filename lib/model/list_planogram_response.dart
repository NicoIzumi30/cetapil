
class ListPlanogramResponse {
  String? status;
  String? message;
  List<Data>? data;

  ListPlanogramResponse({this.status, this.message, this.data});

  ListPlanogramResponse.fromJson(Map<String, dynamic> json) {
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

  static List<ListPlanogramResponse> fromList(List<Map<String, dynamic>> list) {
    return list.map(ListPlanogramResponse.fromJson).toList();
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
  String? channelId;
  String? filename;
  String? path;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  Channel? channel;

  Data({this.id, this.channelId, this.filename, this.path, this.createdAt, this.updatedAt, this.deletedAt, this.channel});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["channel_id"] is String) {
      channelId = json["channel_id"];
    }
    if(json["filename"] is String) {
      filename = json["filename"];
    }
    if(json["path"] is String) {
      path = json["path"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if(json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
    deletedAt = json["deleted_at"];
    if(json["channel"] is Map) {
      channel = json["channel"] == null ? null : Channel.fromJson(json["channel"]);
    }
  }

  static List<Data> fromList(List<Map<String, dynamic>> list) {
    return list.map(Data.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["channel_id"] = channelId;
    _data["filename"] = filename;
    _data["path"] = path;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["deleted_at"] = deletedAt;
    if(channel != null) {
      _data["channel"] = channel?.toJson();
    }
    return _data;
  }
}

class Channel {
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  Channel({this.id, this.name, this.createdAt, this.updatedAt, this.deletedAt});

  Channel.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if(json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
    deletedAt = json["deleted_at"];
  }

  static List<Channel> fromList(List<Map<String, dynamic>> list) {
    return list.map(Channel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["deleted_at"] = deletedAt;
    return _data;
  }
}