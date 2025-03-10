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

  Future<User> call(final String name, final String email,
      final String password, final String username, final String phone) async {
    User userInfo =
        await repository.createUser(email, password, username, name, phone);
    return userInfo;
  }
}
