/// id : "9d7cc874-0604-40c5-9537-1c7a9bc68eb8"
/// question : "Apakah outlet sudah menjual produk GIH"
/// type : "bool"

class FormOutletResponse {
  FormOutletResponse({
      String? id, 
      String? question, 
      String? type,}){
    _id = id;
    _question = question;
    _type = type;
}

  FormOutletResponse.fromJson(dynamic json) {
    _id = json['id'];
    _question = json['question'];
    _type = json['type'];
  }
  String? _id;
  String? _question;
  String? _type;
FormOutletResponse copyWith({  String? id,
  String? question,
  String? type,
}) => FormOutletResponse(  id: id ?? _id,
  question: question ?? _question,
  type: type ?? _type,
);
  String? get id => _id;
  String? get question => _question;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['question'] = _question;
    map['type'] = _type;
    return map;
  }

}