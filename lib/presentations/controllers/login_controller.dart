import 'package:bidhub/core/themes/custom_snackbar_theme.dart';
import 'package:bidhub/presentations/bloc/login/login_bloc.dart';
import 'package:bidhub/presentations/bloc/login/login_event.dart';
import 'package:bidhub/presentations/bloc/login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LoginController extends GetxController with StateMixin {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  @override
  void onInit() {
    intializeController();
    change(true, status: RxStatus.success());
    super.onInit();
  }

  void intializeController() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void handleLogin(BuildContext context) {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      int i = 0;
      if (i == 0) {
        CustomSnackbar.failedSnackbar(
          title: 'Failed',
          message: 'Por favor ingrese su usuario y contraseña',
        );
      }
      return;
    }
    final userBloc = BlocProvider.of<LoginBloc>(context);
    userBloc.add(LoginRequested(
        email: usernameController.text, password: passwordController.text));

    int i = 0;
    userBloc.stream.listen((state) {
      if (state is LoginFailure) {
        if (i == 0) {
          CustomSnackbar.failedSnackbar(
            title: 'Failed',
            message: 'Credenciales incorrectas',
          );
        }
        return;
      } else if (state is LoginSuccess) {
        if (state.user.role == "admin") {
          Get.offAllNamed('/admin');
        } else if (state.user.role == "user") {
          Get.offAllNamed('/home');
        }
        if (i == 0) {
          CustomSnackbar.successSnackbar(
            title: 'Success',
            message: 'Login Correcto',
          );
        }
        return;
      }
    });
  }
}
