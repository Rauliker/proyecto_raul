import 'package:bidhub/data/datasources/court_type.dart';
import 'package:bidhub/data/datasources/user_datasource.dart';
import 'package:bidhub/data/repositories/court_type_repository_impl.dart';
import 'package:bidhub/data/repositories/user_repository_impl.dart';
import 'package:bidhub/domain/repositories/court_type_repository.dart';
import 'package:bidhub/domain/repositories/user_repisitory.dart';
import 'package:bidhub/domain/usercase/court_type_usecase.dart';
import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/language/language_bloc.dart';
import 'package:bidhub/presentations/bloc/login/login_bloc.dart';
import 'package:bidhub/presentations/bloc/register/register_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Data sources

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<PistaTypeRemoteDataSource>(
      () => PistaTypeRemoteDataSourceImpl(sl()));
  // Repositories

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<PistaTypeRepository>(
      () => PistaTypeRepositoryyImpl(remoteDataSource: sl()));

  // Use Cases

  sl.registerLazySingleton(() => CaseLoginUser(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => GetAllPistaType(sl()));
  // Blocs
  sl.registerFactory(() => LanguageBloc());
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerCachedFactory(() => CourtTypeBloc(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
