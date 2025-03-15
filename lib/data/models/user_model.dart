import 'package:bidhub/domain/entities/users.dart';

class UserModel extends User {
  UserModel(
      {required super.id,
      required super.email,
      required super.username,
      required super.password,
      required super.address,
      required super.name,
      required super.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
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
      'phone': phone
    };
  }
}
