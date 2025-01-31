import 'package:bidhub/data/datasources/user_datasource.dart';
import 'package:bidhub/domain/entities/users.dart';
import 'package:bidhub/domain/repositories/user_repisitory.dart';
import 'package:file_picker/file_picker.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String email, String password, String deviceInfo) async {
    return await remoteDataSource.login(email, password, deviceInfo);
  }

  @override
  Future<User> createUser(
      String email,
      String password,
      String username,
      int idprovincia,
      int idmunicipio,
      String calle,
      List<PlatformFile> image,
      int role) async {
    return await remoteDataSource.createUser(email, password, username,
        idprovincia, idmunicipio, calle, image, role);
  }

  @override
  Future<User> getUserByEmail(String email) async {
    return await remoteDataSource.getUserInfo(email);
  }

  @override
  Future<List<User>> getUsersInfo(String email) async {
    return await remoteDataSource.getUsersInfo(email);
  }

  @override
  Future<User> updateUserProfile(String email, String username, int idprovincia,
      int idmunicipio, String calle, List<PlatformFile> imagen) async {
    return await remoteDataSource.updateUserProfile(
        email, username, idprovincia, idmunicipio, calle, imagen);
  }

  @override
  Future<User> updateUserPass(
    String password,
  ) async {
    return await remoteDataSource.updateUserPass(
      password,
    );
  }

  @override
  Future<User> changeBan(
    bool banned,
    String email,
  ) async {
    return await remoteDataSource.changeBan(banned, email);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }
}
