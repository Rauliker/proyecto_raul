import 'package:bidhub/domain/entities/users.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.username,
    required super.password,
    required super.name,
    required super.phone,
    required super.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'name': name,
      'phone': phone,
      'adress': address,
    };
  }
}
