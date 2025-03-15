import 'package:bidhub/data/datasources/court_datasource.dart';
import 'package:bidhub/data/datasources/court_type_datasource.dart';
import 'package:bidhub/data/datasources/reservation_datasource.dart';
import 'package:bidhub/data/datasources/user_datasource.dart';
import 'package:bidhub/data/repositories/court_repository_impl.dart';
import 'package:bidhub/data/repositories/court_type_repository_impl.dart';
import 'package:bidhub/data/repositories/reservation_repository_impl.dart';
import 'package:bidhub/data/repositories/user_repository_impl.dart';
import 'package:bidhub/domain/repositories/court_repository.dart';
import 'package:bidhub/domain/repositories/court_type_repository.dart';
import 'package:bidhub/domain/repositories/reservation_repository.dart';
import 'package:bidhub/domain/repositories/user_repisitory.dart';
import 'package:bidhub/domain/usercase/court_type_usecase.dart';
import 'package:bidhub/domain/usercase/court_usecase.dart';
import 'package:bidhub/domain/usercase/reservation_usecase.dart';
import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/cancelReservation/cancel_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/get_all_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_bloc.dart';
import 'package:bidhub/presentations/bloc/language/language_bloc.dart';
import 'package:bidhub/presentations/bloc/login/login_bloc.dart';
import 'package:bidhub/presentations/bloc/register/register_bloc.dart';
import 'package:bidhub/presentations/bloc/reservation/reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/updateUser/update_user_bloc.dart';
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
  sl.registerLazySingleton<PistaRemoteDataSource>(
      () => PistaRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ReservationRemoteDataSource>(
      () => ReservationRemoteDataSourceImpl(sl()));
  // Repositories

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<PistaTypeRepository>(
      () => PistaTypeRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<PistaRepository>(
      () => PistaRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ReservationRepository>(
      () => ReservationRepositoryImpl(remoteDataSource: sl()));

  // Use Cases

  sl.registerLazySingleton(() => CaseLoginUser(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));
  sl.registerLazySingleton(() => GetAllPistaType(sl()));
  sl.registerLazySingleton(() => GetAllPista(sl()));
  sl.registerLazySingleton(() => GetOnePista(sl()));
  sl.registerLazySingleton(() => CreateReservation(sl()));
  sl.registerLazySingleton(() => GetAllReservation(sl()));
  sl.registerLazySingleton(() => CancelReservation(sl()));
  sl.registerLazySingleton(() => GetUserInfo(sl()));
  sl.registerLazySingleton(() => UpdateUserInfo(sl()));
  // Blocs
  sl.registerFactory(() => LanguageBloc());
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerCachedFactory(() => CourtTypeBloc(sl()));
  sl.registerCachedFactory(() => CourtBloc(sl()));
  sl.registerCachedFactory(() => CourtOneBloc(sl()));
  sl.registerCachedFactory(() => ReservationBloc(sl()));
  sl.registerCachedFactory(() => GetAllReservationBloc(sl()));
  sl.registerCachedFactory(() => CancelReservationBloc(sl()));
  sl.registerCachedFactory(() => GetUserBloc(sl()));
  sl.registerCachedFactory(() => UpdateUserBloc(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
