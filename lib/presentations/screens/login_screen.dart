import 'package:bidhub/core/themes/font_themes.dart';
import 'package:bidhub/core/values/assets.dart';
import 'package:bidhub/core/values/colors.dart';
import 'package:bidhub/presentations/controllers/login_controller.dart';
import 'package:bidhub/presentations/global_widgets/custom_medium_button.dart';
import 'package:bidhub/presentations/global_widgets/custom_textfield.dart';
import 'package:bidhub/presentations/global_widgets/footer_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                label: 'Email',
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
                ontap: () => Get.toNamed('/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
