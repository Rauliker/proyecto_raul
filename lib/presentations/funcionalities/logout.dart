import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/bloc/users/logout_user_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';

Future<void> logout(BuildContext context) async {
  context.read<LogoutUserBloc>().add(const LogoutRequested());

  await Future.delayed(const Duration(milliseconds: 200));
  if (!context.mounted) return;
  context.go('/login');
}
