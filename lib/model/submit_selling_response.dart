/// status : "OK"
/// message : "Save selling list successfully."

class SubmitSellingResponse {
  SubmitSellingResponse({
      String? status, 
      String? message,}){
    _status = status;
    _message = message;
}

  SubmitSellingResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  String? _status;
  String? _message;
SubmitSellingResponse copyWith({  String? status,
  String? message,
}) => SubmitSellingResponse(  status: status ?? _status,
  message: message ?? _message,
);
  String? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}