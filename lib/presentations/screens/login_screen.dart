import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_raul/presentations/appbars/default_appbar.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';
import 'package:proyecto_raul/presentations/funcionalities/get_device_info.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          DefaultAppBar(mesage: AppLocalizations.of(context)!.appTitleLogin),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            // context
            //     .read<UserBloc>()
            //     .add(UserOtherDataRequest(email: state.user.email));

            if (!context.mounted) return;
            context
                .read<UserBloc>()
                .add(UserDataRequest(email: state.user.email));
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!.loginSuccess)),
            );

            if (!context.mounted) return;
            context.go('/home');
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(AppLocalizations.of(context)!
                      .loginFailure(state.message))),
            );
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.emailLabel),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.passwordLabel),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String deviceInfo = await getDeviceInfo();
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    if (!context.mounted) return;
                    context.read<UserBloc>().add(LoginRequested(
                        email: email,
                        password: password,
                        deviceInfo: deviceInfo));
                  },
                  child: Text(
                    AppLocalizations.of(context)!.loginButton,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  child: Text(AppLocalizations.of(context)!.signupPrompt),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
