import 'package:bidhub/injection_container.dart' as di;
import 'package:bidhub/presentations/bloc/users/users_bloc.dart';
import 'package:bidhub/presentations/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final List<GetPage> routes = [
  GetPage(
    name: '/login',
    page: () => BlocProvider(
      create: (context) => di.sl<UserBloc>(),
      child: const LoginPage(),
    ),
  ),
];
