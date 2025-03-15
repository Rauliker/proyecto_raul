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
  Future<User> createUser(String email, String password, String username,
      String name, String phone, String address) async {
    return await remoteDataSource.createUser(
        email, password, username, name, phone, address);
  }

  @override
  Future<User> getUser() async {
    return await remoteDataSource.autoLogin();
  }

  @override
  Future<User> updateUser(
    int id,
    String username,
    String name,
    String phone,
    String address,
  ) async {
    return await remoteDataSource.updateUser(
      id,
      username,
      name,
      phone,
      address,
    );
  }
}
