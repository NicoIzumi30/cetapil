/// status : "OK"
/// message : "Get the outlet list successfully."
/// data : [{"id":"9d96c0f2-2c77-4a28-8822-0ffa4fa6f4f4","channel":{"id":"9d883c18-d732-4313-ae4b-6c11acb9ac7a","name":"Minimarket"},"path_pdf":"/pdf/product-knowledge/9d883c18-d732-4313-ae4b-6c11acb9ac7a/054_surat_izin_kelas_lomba_pubg_pimaposma_1732708077.pdf","path_video":"/video/product-knowledge/9d883c18-d732-4313-ae4b-6c11acb9ac7a/ok_1732708077.mp4"},{"id":"9d96c119-5677-4575-b82f-fe396e72128b","channel":{"id":"9d883c18-d9ce-4dca-a5f9-7cd0ba9209fe","name":"HSM (Hyper Suparmarket)"},"path_pdf":"/pdf/product-knowledge/9d883c18-d9ce-4dca-a5f9-7cd0ba9209fe/panitia_tm_1732708103.pdf","path_video":"/video/product-knowledge/9d883c18-d9ce-4dca-a5f9-7cd0ba9209fe/ok_1732708103.mp4"},{"id":"9d96c148-5fdc-4d48-bd4c-3b8790159c54","channel":{"id":"9d883c18-d831-4dca-a444-0ca859b96eff","name":"HFS/GT"},"path_pdf":"/pdf/product-knowledge/9d883c18-d831-4dca-a444-0ca859b96eff/045_surat_izin_kelas_lomba_tilawah_pimaposma_2024_1732708134.pdf","path_video":"/video/product-knowledge/9d883c18-d831-4dca-a444-0ca859b96eff/ok_1732708134.mp4"},{"id":"9d96c16f-96c5-4b32-81be-ac1083989273","channel":{"id":"9d883c18-d373-4e16-a89d-c3959c4479e9","name":"Chain Pharmacy"},"path_pdf":"/pdf/product-knowledge/9d883c18-d373-4e16-a89d-c3959c4479e9/fiba_scoresheet_1_1732708159.pdf","path_video":"/video/product-knowledge/9d883c18-d373-4e16-a89d-c3959c4479e9/ok_1732708160.mp4"}]

class ListKnowledgeResponse {
  ListKnowledgeResponse({
      String? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  ListKnowledgeResponse.fromJson(dynamic json) {
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
ListKnowledgeResponse copyWith({  String? status,
  String? message,
  List<Data>? data,
}) => ListKnowledgeResponse(  status: status ?? _status,
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

/// id : "9d96c0f2-2c77-4a28-8822-0ffa4fa6f4f4"
/// channel : {"id":"9d883c18-d732-4313-ae4b-6c11acb9ac7a","name":"Minimarket"}
/// path_pdf : "/pdf/product-knowledge/9d883c18-d732-4313-ae4b-6c11acb9ac7a/054_surat_izin_kelas_lomba_pubg_pimaposma_1732708077.pdf"
/// path_video : "/video/product-knowledge/9d883c18-d732-4313-ae4b-6c11acb9ac7a/ok_1732708077.mp4"

class Data {
  Data({
      String? id, 
      Channel? channel, 
      String? pathPdf, 
      String? pathVideo,}){
    _id = id;
    _channel = channel;
    _pathPdf = pathPdf;
    _pathVideo = pathVideo;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _channel = json['channel'] != null ? Channel.fromJson(json['channel']) : null;
    _pathPdf = json['path_pdf'];
    _pathVideo = json['path_video'];
  }
  String? _id;
  Channel? _channel;
  String? _pathPdf;
  String? _pathVideo;
Data copyWith({  String? id,
  Channel? channel,
  String? pathPdf,
  String? pathVideo,
}) => Data(  id: id ?? _id,
  channel: channel ?? _channel,
  pathPdf: pathPdf ?? _pathPdf,
  pathVideo: pathVideo ?? _pathVideo,
);
  String? get id => _id;
  Channel? get channel => _channel;
  String? get pathPdf => _pathPdf;
  String? get pathVideo => _pathVideo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    if (_channel != null) {
      map['channel'] = _channel?.toJson();
    }
    map['path_pdf'] = _pathPdf;
    map['path_video'] = _pathVideo;
    return map;
  }

}

/// id : "9d883c18-d732-4313-ae4b-6c11acb9ac7a"
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