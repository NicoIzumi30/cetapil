import 'dart:io';

class VisibilityData {
  final String id;
  final VisibilityType? typeVisibility;
  final VisibilityType? typeVisual;
  final String? condition;
  final File? image1;
  final File? image2;

  VisibilityData({
    required this.id,
    this.typeVisibility,
    this.typeVisual,
    this.condition,
    this.image1,
    this.image2,
  });
}

class VisibilityType {
  final String? id;
  final String? type;

  VisibilityType({
    this.id,
    this.type,
  });
}