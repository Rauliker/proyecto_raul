import 'package:bidhub/injection_container.dart' as di;
import 'package:bidhub/main.dart';
import 'package:bidhub/presentations/bloc/users/users_bloc.dart';
import 'package:bidhub/presentations/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (context) => di.sl<UserBloc>(),
          child: const LoginPage(),
        ),
      ),
      // GoRoute(
      //   path: '/signup',
      //   builder: (context, state) => MultiBlocProvider(
      //     providers: [
      //       BlocProvider(
      //         create: (context) => di.sl<UserBloc>(),
      //       ),
      //     ],
      //     child: const CrearUsuarioPage(),
      //   ),
      // ),
    ],
    redirect: (context, state) async {});
