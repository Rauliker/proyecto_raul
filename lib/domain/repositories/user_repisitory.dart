import 'package:bidhub/domain/entities/users.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> createUser(
      final String email,
      final String password,
      final String username,
      final String name,
      final String phone,
      final String address);
  Future<User> getUser();
  Future<User> updateUser(
    int id,
    String username,
    String name,
    String phone,
    String address,
  );
}
