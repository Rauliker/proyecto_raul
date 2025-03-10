import 'package:bidhub/domain/entities/users.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> createUser(final String name, final String email,
      final String password, final String username, final String phone);
}
