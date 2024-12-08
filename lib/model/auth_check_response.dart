// auth_check_response.dart
class AuthCheckResponse {
  final String? status;
  final String? message;
  final AuthUserData? data;

  AuthCheckResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AuthCheckResponse.fromJson(Map<String, dynamic> json) {
    return AuthCheckResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? AuthUserData.fromJson(json['data']) : null,
    );
  }
}

class AuthUserData {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? longitude;
  final String? latitude;
  final String? city;
  final String? region;
  final String? address;
  final bool? active;
  final List<Role>? roles;
  final List<Permission>? permissions;

  AuthUserData({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.longitude,
    this.latitude,
    this.city,
    this.region,
    this.address,
    this.active,
    this.roles,
    this.permissions,
  });

  factory AuthUserData.fromJson(Map<String, dynamic> json) {
    return AuthUserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      city: json['city'],
      region: json['region'],
      address: json['address'],
      active: json['active'],
      roles: json['roles'] != null 
          ? List<Role>.from(json['roles'].map((x) => Role.fromJson(x)))
          : null,
      permissions: json['permissions'] != null 
          ? List<Permission>.from(json['permissions'].map((x) => Permission.fromJson(x)))
          : null,
    );
  }
}

class Role {
  final String? id;
  final String? name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Permission {
  final String? id;
  final String? name;

  Permission({
    this.id,
    this.name,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      name: json['name'],
    );
  }
}