import 'package:bidhub/domain/entities/users.dart';
import 'package:bidhub/domain/repositories/user_repisitory.dart';

class CaseLoginUser {
  final UserRepository repository;

  CaseLoginUser(this.repository);

  Future<User> call(String email, String password) async {
    User user = await repository.login(email, password);
    return user;
  }
}

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<User> call(
      final String email,
      final String password,
      final String address,
      final String name,
      final String username,
      final String phone) async {
    User userInfo = await repository.createUser(
        email, password, username, name, phone, address);
    return userInfo;
  }
}

class GetUserInfo {
  final UserRepository repository;

  GetUserInfo(this.repository);

  Future<User> call() async {
    User userInfo = await repository.getUser();
    return userInfo;
  }
}

class UpdateUserInfo {
  final UserRepository repository;

  UpdateUserInfo(this.repository);

  Future<User> call(
    int id,
    String username,
    String name,
    String phone,
    String address,
  ) async {
    User userInfo =
        await repository.updateUser(id, username, name, phone, address);
    return userInfo;
  }
}
