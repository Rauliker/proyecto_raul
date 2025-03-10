import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String username;
  final String phone;

  const RegisterRequested(
      {required this.email,
      required this.password,
      required this.name,
      required this.username,
      required this.phone});

  @override
  List<Object?> get props => [email, password, name, username, phone];
}

class LogoutRequested extends RegisterEvent {
  const LogoutRequested();

  @override
  List<Object?> get props => [];
}
