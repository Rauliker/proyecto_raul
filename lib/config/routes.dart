import 'package:bidhub/injection_container.dart' as di;
import 'package:bidhub/presentations/bloc/getCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/login/login_bloc.dart';
import 'package:bidhub/presentations/bloc/register/register_bloc.dart';
import 'package:bidhub/presentations/screens/home_screen.dart';
import 'package:bidhub/presentations/screens/login_screen.dart';
import 'package:bidhub/presentations/screens/register_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

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
      ],
      child: const HomePage(),
    ),
  ),
];
