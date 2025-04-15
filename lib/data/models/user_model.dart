import 'package:bidhub/domain/entities/users.dart';

class UserModel extends User {
  UserModel(
      {required super.id,
      required super.email,
      required super.username,
      required super.password,
      required super.address,
      required super.name,
      required super.phone,
      required super.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      address: json['adrress'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'address': address,
      'name': name,
      'phone': phone,
      'role': role
    };
  }
}
