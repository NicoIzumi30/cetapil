class Outlet {
  final String id;
  final String salesName;
  final String outletName;
  final String category;
  final String longitude;
  final String latitude;
  final String address;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Outlet( {
    required this.id,
    required this.salesName,
    required this.outletName,
    required this.category,
    required this.longitude,
    required this.latitude,
    required this.address,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'salesName': salesName,
    'outletName': outletName,
    'category': category,
    'longitude': longitude,
    'latitude': latitude,
    'address': address,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };

  factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
    id: json['id'],
    salesName: json['salesName'],
    outletName: json['outletName'],
    category: json['category'],
    longitude: json['longitude'],
    latitude: json['latitude'],
    address: json['address'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
  );
}

class OutletForm {
  final String id;
  final String question;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  OutletForm({
    required this.id,
    required this.question,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'type': type,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };

  factory OutletForm.fromJson(Map<String, dynamic> json) => OutletForm(
    id: json['id'],
    question: json['question'],
    type: json['type'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
  );
}

class OutletFormAnswer {
  final String id;
  final String outletId;
  final String outletFormId;
  final String answer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  OutletFormAnswer({
    required this.id,
    required this.outletId,
    required this.outletFormId,
    required this.answer,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'outlet_id': outletId,
    'outlet_form_id': outletFormId,
    'answer': answer,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
  };

  factory OutletFormAnswer.fromJson(Map<String, dynamic> json) => OutletFormAnswer(
    id: json['id'],
    outletId: json['outlet_id'],
    outletFormId: json['outlet_form_id'],
    answer: json['answer'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
  );
}