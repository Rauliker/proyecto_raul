import 'package:bidhub/core/themes/custom_snackbar_theme.dart';
import 'package:bidhub/presentations/bloc/register/register_bloc.dart';
import 'package:bidhub/presentations/bloc/register/register_event.dart';
import 'package:bidhub/presentations/bloc/register/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    phoneNumberController.addListener(formatPhoneNumber);
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

  void formatPhoneNumber() {
    // Obtiene el texto del controlador del número de teléfono y elimina todos los caracteres que no sean dígitos.
    String input = phoneNumberController.text.replaceAll(RegExp(r'\D'), '');

    // Si la longitud del texto es mayor a 9, corta el texto a los primeros 9 caracteres.
    if (input.length > 9) {
      input = input.substring(0, 9);
    }

    // Inicializa una cadena vacía para el número de teléfono formateado.
    String formatted = '';

    // Itera sobre cada carácter del texto de entrada.
    for (int i = 0; i < input.length; i++) {
      // Añade un espacio después de los 3er, 5to, 7mo y 9no caracteres.
      if (i == 3 || i == 5 || i == 7 || i == 9) {
        formatted += ' ';
      }
      // Añade el carácter actual a la cadena formateada.
      formatted += input[i];
    }

    // Actualiza el valor del controlador del número de teléfono con el texto formateado.
    phoneNumberController.value = TextEditingValue(
      text: formatted,
      // Coloca el cursor al final del texto formateado.
      selection: TextSelection.collapsed(offset: formatted.length),
    );
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
        int.tryParse(phoneNumberController.text.replaceAll(' ', '')) != null &&
            phoneNumberController.text.replaceAll(' ', '').length == 9;
    final isValidEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(emailController.text);

    return isValidEmail && isValidPhoneNumber && !isNameContainNumber;
  }

  String getFormattedPhoneNumber() {
    return phoneNumberController.text.replaceAll(' ', '');
  }

  void handleRegister(
    BuildContext context,
  ) async {
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
    final phoneNumber = getFormattedPhoneNumber();
    final email = emailController.text;
    final username = usernameController.text;
    final password = passwordController.text;
    final userBloc = BlocProvider.of<RegisterBloc>(context);
    userBloc.add(RegisterRequested(
      name: name,
      address: address,
      phone: phoneNumber,
      email: email,
      username: username,
      password: password,
    ));
    userBloc.stream.listen((state) {
      if (state is RegisterFailure) {
        CustomSnackbar.failedSnackbar(
          title: 'Failed',
          message: state.message.replaceAll('Exception:', ''),
        );
        return;
      } else if (state is RegisterSuccess) {
        Get.offAllNamed('/login');
        CustomSnackbar.successSnackbar(
          title: 'Success',
          message: 'Registro Correcto',
        );
        return;
      }
    });
  }
}
