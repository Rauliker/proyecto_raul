import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends UserEvent {
  final String email;
  final String password;
  final String deviceInfo;

  const LoginRequested(
      {required this.email, required this.password, required this.deviceInfo});

  @override
  List<Object?> get props => [email, password, deviceInfo];
}

class LogoutRequested extends UserEvent {
  const LogoutRequested();

  @override
  List<Object?> get props => [];
}

class UserDataRequest extends UserEvent {
  final String email;

  const UserDataRequest({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class UserCreateRequest extends UserEvent {
  final String email;
  final String password;
  final String username;
  final int idprovincia;
  final int idmunicipio;
  final String calle;
  final List<PlatformFile> imagen;
  final int role;

  const UserCreateRequest(
      {required this.email,
      required this.password,
      required this.username,
      required this.idprovincia,
      required this.idmunicipio,
      required this.calle,
      required this.imagen,
      required this.role});

  @override
  List<Object?> get props => [
        email,
        password,
        username,
        idprovincia,
        idmunicipio,
        calle,
        imagen,
        role
      ];
}

class UserOtherDataRequest extends UserEvent {
  final String email;

  const UserOtherDataRequest({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class UserUpdateProfile extends UserEvent {
  final String email;
  final String username;
  final int idprovincia;
  final int idmunicipio;
  final String calle;
  final List<PlatformFile> imagen;

  const UserUpdateProfile(
      {required this.email,
      required this.username,
      required this.idprovincia,
      required this.idmunicipio,
      required this.calle,
      required this.imagen});

  @override
  List<Object?> get props =>
      [email, username, idprovincia, idmunicipio, calle, imagen];
}

class UserUpdateBan extends UserEvent {
  final bool banned;
  final String email;

  const UserUpdateBan({required this.banned, required this.email});

  @override
  List<Object?> get props => [
        banned,
        email,
      ];
}

class UserUpdatePass extends UserEvent {
  final String password;

  const UserUpdatePass({required this.password});

  @override
  List<Object?> get props => [
        password,
      ];
}
