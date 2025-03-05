import 'package:bidhub/data/datasources/user_datasource.dart';
import 'package:bidhub/data/repositories/user_repository_impl.dart';
import 'package:bidhub/domain/repositories/user_repisitory.dart';
import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/language/language_bloc.dart';
import 'package:bidhub/presentations/bloc/users/users_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Data sources

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl()));
  // Repositories

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));

  // Use Cases

  sl.registerLazySingleton(() => CaseUser(sl()));
  sl.registerLazySingleton(() => CaseUserInfo(sl()));
  sl.registerLazySingleton(() => CaseUsersInfo(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => CaseLogoutUser(sl()));
  sl.registerLazySingleton(() => CaseUserUpdateBan(sl()));
  sl.registerLazySingleton(() => CaseUseUserUpdateProfile(sl()));
  sl.registerLazySingleton(() => CaseUserUpdatePass(sl()));
  // Blocs
  sl.registerFactory(() => LanguageBloc());
  sl.registerFactory(() => UserBloc(sl(), sl(), sl(), sl(), sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
