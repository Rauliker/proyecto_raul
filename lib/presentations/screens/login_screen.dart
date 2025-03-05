import 'package:bidhub/core/themes/custom_snackbar_theme.dart';
import 'package:bidhub/core/themes/font_themes.dart';
import 'package:bidhub/core/values/assets.dart';
import 'package:bidhub/core/values/colors.dart';
import 'package:bidhub/presentations/bloc/users/users_bloc.dart';
import 'package:bidhub/presentations/bloc/users/users_event.dart';
import 'package:bidhub/presentations/bloc/users/users_state.dart';
import 'package:bidhub/presentations/global_widgets/custom_medium_button.dart';
import 'package:bidhub/presentations/global_widgets/custom_textfield.dart';
import 'package:bidhub/presentations/global_widgets/footer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

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

  void handleLogin(
    BuildContext context,
  ) {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      CustomSnackbar.failedSnackbar(
        title: 'Failed',
        message: 'Please input username and password',
      );
      return;
    }
    final userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.add(LoginRequested(
        email: usernameController.text, password: passwordController.text));
    if (state is LoginSuccess) {
      CustomSnackbar.successSnackbar(
        title: 'Success',
        message: 'Login successful!',
      );

      return;
    } else {
      CustomSnackbar.failedSnackbar(
        title: 'Failed',
        message: 'Credenciales Incorrectas',
      );
      return;
    }
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.15,
              ),
              Image.asset(heroLoginImage),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login',
                  style: headline4,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                textStyle: headline6,
                isObscure: false,
                controller: controller.usernameController,
                label: 'Username',
                icon: Icons.person,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                textStyle: headline6,
                isObscure: true,
                controller: controller.passwordController,
                label: 'Password',
                icon: Icons.lock,
              ),
              const SizedBox(height: 30),
              CustomMediumButton(
                color: blue,
                label: 'Login',
                onTap: () => controller.handleLogin(context),
              ),
              const SizedBox(height: 50),
              FooterText(
                label: "¿No tienes una cuenta? ",
                labelWithFunction: 'Unete',
                ontap: () => context.go('/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
