import 'package:intl/intl.dart';

class UserResponseDTO {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String email;
  final String? address;
  final String? phoneNumber;
  final String role;
  final String? bio;

  UserResponseDTO({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.email,
    this.address,
    this.phoneNumber,
    required this.role,
    this.bio,
  });

  factory UserResponseDTO.fromJson(Map<String, dynamic> json) {
    return UserResponseDTO(
      id: json['id'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      name: json['name'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      bio: json['bio'],
    );
  }
}

class CreateUserDTO {
  final String name;
  final String email;
  final String password;
  final String? address;
  final String? phoneNumber;
  final String? bio;
  final String role;

  CreateUserDTO({
    required this.name,
    required this.email,
    required this.password,
    this.address,
    this.phoneNumber,
    this.bio,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'role': role,
    };
  }
}

class UpdateUserDTO {
  final String? name;
  final String? email;
  final String? password;
  final String? address;
  final String? phoneNumber;
  final String? bio;

  UpdateUserDTO({
    this.name,
    this.email,
    this.password,
    this.address,
    this.phoneNumber,
    this.bio,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'phoneNumber': phoneNumber,
      'bio': bio,
    }..removeWhere((key, value) => value == null);
  }
}

class AuthResponseDTO {
  final UserResponseDTO user;
  final String accessToken;
  final String refreshToken;

  AuthResponseDTO({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseDTO.fromJson(Map<String, dynamic> json) {
    return AuthResponseDTO(
      user: UserResponseDTO.fromJson(json['user']),
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
