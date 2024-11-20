class FormOutletResponse {
  final String id;
  final String question;
  final String type;

  FormOutletResponse({
    required this.id,
    required this.question,
    required this.type,
  });

  factory FormOutletResponse.fromJson(Map<String, dynamic> json) => FormOutletResponse(
    id: json['id'].toString(),
    question: json['question'].toString(),
    type: json['type'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'type': type,
  };
}