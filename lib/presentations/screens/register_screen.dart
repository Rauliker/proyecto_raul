import 'package:bidhub/core/themes/custom_snackbar_theme.dart';
import 'package:bidhub/core/themes/font_themes.dart';
import 'package:bidhub/core/values/assets.dart';
import 'package:bidhub/core/values/colors.dart';
import 'package:bidhub/presentations/global_widgets/custom_medium_button.dart';
import 'package:bidhub/presentations/global_widgets/custom_textfield.dart';
import 'package:bidhub/presentations/global_widgets/footer_text.dart';
import 'package:bidhub/presentations/global_widgets/loading_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController with StateMixin {
  late final TextEditingController fullNameController;
  late final TextEditingController addressController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController emailController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

  @override
  void onInit() {
    initializeController();

    change(true, status: RxStatus.success());

    super.onInit();
  }

  void initializeController() {
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  bool isAnyEmptyField() {
    return fullNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty;
  }

  bool isAllFieldValid() {
    final isNameContainNumber = fullNameController.text.contains(
      RegExp(r'[0-9]'),
    );
    final isValidPhoneNumber =
        int.tryParse(phoneNumberController.text) != null &&
            phoneNumberController.text.length == 9;
    final isValidEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(emailController.text);

    return isValidEmail && isValidPhoneNumber && !isNameContainNumber;
  }

  void handleRegister() async {
    if (isAnyEmptyField()) {
      CustomSnackbar.failedSnackbar(
        title: 'Error de Registro',
        message: 'Por favor llene todos los campos',
      );
      return;
    }

    if (!isAllFieldValid()) {
      CustomSnackbar.failedSnackbar(
        title: 'Error de Registro',
        message: 'Datos invalidos',
      );
      return;
    }

    final name = fullNameController.text;
    final address = addressController.text;
    final phoneNumber = phoneNumberController.text;
    final email = emailController.text;
    final username = usernameController.text;
    final password = passwordController.text;
    print('Name: $name');
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final RegisterController controller = Get.put(RegisterController());

  List<CustomTextField> regiterFields() {
    return [
      CustomTextField(
        textStyle: textfieldText,
        controller: controller.fullNameController,
        icon: Icons.account_circle,
        label: 'Full Name',
        isObscure: false,
      ),
      CustomTextField(
        textStyle: textfieldText,
        controller: controller.addressController,
        icon: Icons.home,
        label: 'Address',
        isObscure: false,
      ),
      CustomTextField(
        textStyle: textfieldText,
        controller: controller.phoneNumberController,
        icon: Icons.phone,
        label: 'Phone Number',
        isObscure: false,
      ),
      CustomTextField(
        textStyle: textfieldText,
        controller: controller.emailController,
        icon: Icons.email,
        label: 'Email',
        isObscure: false,
      ),
      CustomTextField(
        textStyle: textfieldText,
        controller: controller.usernameController,
        icon: Icons.person,
        label: 'Username',
        isObscure: false,
      ),
      CustomTextField(
        textStyle: textfieldText,
        controller: controller.passwordController,
        icon: Icons.lock,
        label: 'Password',
        isObscure: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              heroRegisterImage,
              width: Get.width * 0.49,
            ),
            const SizedBox(
              height: 25,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Register',
                style: headline4,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ...regiterFields()
                .map(
                  (field) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: field,
                  ),
                )
                .toList(),
            const SizedBox(
              height: 25,
            ),
            CustomMediumButton(
              label: 'Sign Up',
              onTap: controller.handleRegister,
              color: blue,
            ),
            SizedBox(
              height: 50,
              child: controller.obx(
                (state) => const SizedBox.shrink(),
                onLoading: const Center(
                  child: LoadingSpinkit(),
                ),
              ),
            ),
            FooterText(
              label: 'Already Registered? ',
              labelWithFunction: 'Login',
              ontap: () => Get.toNamed('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
