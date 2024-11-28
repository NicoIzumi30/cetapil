import 'dart:io';

class Visibility {
  TypeVisibility? typeVisibility;
  TypeVisual? typeVisual;
  String? condition;
  File? image1;
  File? image2;

  // Constructor
  Visibility({
    this.typeVisibility,
    this.typeVisual,
    this.condition,
    this.image1,
    this.image2,
  });

  // Factory method for creating an instance from a JSON map
  factory Visibility.fromJson(Map<String, dynamic> json) {
    return Visibility(
      typeVisibility: json['typeVisibility'] != null
          ? TypeVisibility.fromJson(json['typeVisibility'])
          : null,
      typeVisual: json['typeVisual'] != null
          ? TypeVisual.fromJson(json['typeVisual'])
          : null,
      condition: json['condition'] as String?,
      image1: json['image1'] != null ? File(json['image1'] as String) : null,
      image2: json['image2'] != null ? File(json['image2'] as String) : null,
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'typeVisibility': typeVisibility?.toJson(),
      'typeVisual': typeVisual?.toJson(),
      'condition': condition,
      'image1': image1?.path, // Convert File to String path
      'image2': image2?.path, // Convert File to String path
    };
  }
}

class TypeVisibility {
  String? id;
  String? type;

  // Constructor
  TypeVisibility({this.id, this.type});

  // Factory method for creating an instance from a JSON map
  factory TypeVisibility.fromJson(Map<String, dynamic> json) {
    return TypeVisibility(
      id: json['id'] as String?,
      type: json['type'] as String?,
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}

class TypeVisual {
  String? id;
  String? type;

  // Constructor
  TypeVisual({this.id, this.type});

  // Factory method for creating an instance from a JSON map
  factory TypeVisual.fromJson(Map<String, dynamic> json) {
    return TypeVisual(
      id: json['id'] as String?,
      type: json['type'] as String?,
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
    };
  }
}
