import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:bidhub/data/datasources/provincias_datasource.dart';
import 'package:bidhub/data/datasources/subastas_datasource.dart';
import 'package:bidhub/data/datasources/user_datasource.dart';
import 'package:bidhub/data/repositories/prov_repository_impl.dart';
import 'package:bidhub/data/repositories/sub_repository_impl.dart';
import 'package:bidhub/data/repositories/user_repository_impl.dart';
import 'package:bidhub/domain/repositories/prov_repository.dart';
import 'package:bidhub/domain/repositories/sub_repository.dart';
import 'package:bidhub/domain/repositories/user_repisitory.dart';
import 'package:bidhub/domain/usercase/prov_usercase.dart';
import 'package:bidhub/domain/usercase/subastas_usecase.dart';
import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/language/language_bloc.dart';
import 'package:bidhub/presentations/bloc/provincias/prov_bloc.dart';
import 'package:bidhub/presentations/bloc/subastas/subasta_bloc.dart';
import 'package:bidhub/presentations/bloc/users/ban_user_bloc.dart';
import 'package:bidhub/presentations/bloc/users/logout_user_bloc.dart';
import 'package:bidhub/presentations/bloc/users/other_user_bloc.dart';
import 'package:bidhub/presentations/bloc/users/users_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Data sources
  sl.registerLazySingleton<ProvRemoteDataSource>(
      () => ProvRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<SubastasRemoteDataSource>(
      () => SubastasRemoteDataSource(sl()));

  // Repositories
  sl.registerLazySingleton<ProvRepository>(
      () => ProvRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<SubastasRepository>(
      () => SubastasRepositoryImpl(remoteDataSource: sl()));

  // Use Cases
  sl.registerLazySingleton(() => CaseProvInfo(sl()));

  sl.registerLazySingleton(() => CaseUser(sl()));
  sl.registerLazySingleton(() => CaseUserInfo(sl()));
  sl.registerLazySingleton(() => CaseUsersInfo(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => CaseLogoutUser(sl()));
  sl.registerLazySingleton(() => CaseUserUpdateBan(sl()));
  sl.registerLazySingleton(() => CaseUseUserUpdateProfile(sl()));
  sl.registerLazySingleton(() => CaseUserUpdatePass(sl()));

  sl.registerLazySingleton(() => CaseFetchAllSubastas(sl()));
  sl.registerLazySingleton(() => CaseFetchSubastasPorUsuario(sl()));
  sl.registerLazySingleton(() => CaseFetchSubastasDeOtroUsuario(sl()));
  sl.registerLazySingleton(() => CaseCreateSubasta(sl()));
  sl.registerLazySingleton(() => CaseUpdateSubasta(sl()));
  sl.registerLazySingleton(() => CaseDeleteSubasta(sl()));
  sl.registerLazySingleton(() => CaseFetchSubastasPorId(sl()));

  sl.registerLazySingleton(() => CaseMakePuja(sl()));

  // Blocs
  sl.registerFactory(() => ProvBloc(sl()));
  sl.registerFactory(() => LanguageBloc());
  sl.registerFactory(() => UserBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => OtherUserBloc(sl()));
  sl.registerFactory(() => BanUserBloc(sl()));
  sl.registerFactory(() => LogoutUserBloc(sl()));
  sl.registerFactory(
      () => SubastasBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
