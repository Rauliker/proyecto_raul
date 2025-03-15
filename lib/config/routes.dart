import 'package:bidhub/injection_container.dart' as di;
import 'package:bidhub/presentations/bloc/cancelReservation/cancel_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/get_all_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_bloc.dart';
import 'package:bidhub/presentations/bloc/login/login_bloc.dart';
import 'package:bidhub/presentations/bloc/register/register_bloc.dart';
import 'package:bidhub/presentations/bloc/reservation/reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/updateUser/update_user_bloc.dart';
import 'package:bidhub/presentations/screens/home_screen.dart';
import 'package:bidhub/presentations/screens/login_screen.dart';
import 'package:bidhub/presentations/screens/one_court_view.dart';
import 'package:bidhub/presentations/screens/register_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

final List<GetPage> routes = [
  GetPage(
    name: '/login',
    page: () => BlocProvider(
      create: (context) => di.sl<LoginBloc>(),
      child: const LoginPage(),
    ),
  ),
  GetPage(
    name: '/register',
    page: () => BlocProvider(
      create: (context) => di.sl<RegisterBloc>(),
      child: const RegisterPage(),
    ),
  ),
  GetPage(
    name: '/home',
    page: () => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CourtTypeBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CourtBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CancelReservationBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<GetAllReservationBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<GetUserBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<UpdateUserBloc>(),
        ),
      ],
      child: const HomePage(),
    ),
  ),
  GetPage(
    name: '/court-detail/:id',
    page: () => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CourtOneBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<ReservationBloc>(),
        ),
      ],
      child: const OneCourtOneView(),
    ),
  ),
];
