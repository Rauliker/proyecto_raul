import 'package:bidhub/data/datasources/user_datasource.dart';
import 'package:bidhub/domain/entities/users.dart';
import 'package:bidhub/domain/repositories/user_repisitory.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<User> createUser(final String name, final String email,
      final String password, final String username, final String phone) async {
    return await remoteDataSource.createUser(
        email, password, username, name, phone);
  }
}
