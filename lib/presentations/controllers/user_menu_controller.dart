import 'package:bidhub/config/secure_storage.dart';
import 'package:bidhub/core/themes/custom_snackbar_theme.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_bloc.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_event.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_state.dart';
import 'package:bidhub/presentations/bloc/updateUser/update_user_bloc.dart';
import 'package:bidhub/presentations/bloc/updateUser/update_user_event.dart';
import 'package:bidhub/presentations/bloc/updateUser/update_user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserMenuController extends GetxController {
  final BuildContext context;
  late final TextEditingController fullNameController;
  late final TextEditingController addressController;
  late final TextEditingController phoneNumberController;
  late final TextEditingController emailController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late int id;
  var hasToken = false.obs;
  final SecureStorageService _secureStorage = SecureStorageService();

  UpdateUserMenuController(this.context);

  @override
  Future<void> onInit() async {
    super.onInit();
    initializeController();
    phoneNumberController.addListener(formatPhoneNumber);
    checkToken();
    if (await checkToken()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchUserInfo();
      });
    }
  }

  void _fetchUserInfo() {
    context.read<GetUserBloc>().add(const GetUserCreate());
  }

  void initializeController() {
    id = 0;
    fullNameController = TextEditingController();
    addressController = TextEditingController();
    phoneNumberController = TextEditingController();
    emailController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void formatPhoneNumber() {
    String input = phoneNumberController.text.replaceAll(RegExp(r'\D'), '');
    if (input.length > 9) {
      input = input.substring(0, 9);
    }
    String formatted = '';
    for (int i = 0; i < input.length; i++) {
      if (i == 3 || i == 5 || i == 7 || i == 9) {
        formatted += ' ';
      }
      formatted += input[i];
    }
    phoneNumberController.value = TextEditingValue(
      text: formatted,
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
    final isNameContainNumber =
        fullNameController.text.contains(RegExp(r'[0-9]'));
    final isValidPhoneNumber =
        int.tryParse(phoneNumberController.text.replaceAll(' ', '')) != null &&
            phoneNumberController.text.replaceAll(' ', '').length == 9;
    return isValidPhoneNumber && !isNameContainNumber;
  }

  String getFormattedPhoneNumber() {
    return phoneNumberController.text.replaceAll(' ', '');
  }

  List<BlocListener> buildBlocListeners() {
    return [
      BlocListener<GetUserBloc, GetUserState>(
        listener: (context, state) {
          if (state is GetUserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
      BlocListener<UpdateUserBloc, UpdateUserState>(
        listener: (context, state) {
          if (state is UpdateUserFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    ];
  }

  void handleUpdateUser(BuildContext context) async {
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
    final userBloc = BlocProvider.of<UpdateUserBloc>(context);
    userBloc.add(UpdateUserCreate(
      id: id,
      name: fullNameController.text,
      address: addressController.text,
      phone: getFormattedPhoneNumber(),
      username: usernameController.text,
    ));
    userBloc.stream.listen((state) {
      if (state is UpdateUserFailure) {
        int i = 0;
        if (i == 0) {
          CustomSnackbar.failedSnackbar(
            title: 'Failed',
            message: state.message.replaceAll('Exception:', ''),
          );
          i++;
        }
      } else if (state is UpdateUserSuccess) {
        int i = 0;
        if (i == 0) {
          CustomSnackbar.successSnackbar(
            title: 'Success',
            message: 'Datos actualizados',
          );

          _fetchUserInfo();
          i++;
        }
      }
    });
  }

  Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    hasToken.value = token != null && token.isNotEmpty;
    return hasToken.value;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await _secureStorage.deleteData('email');
    await _secureStorage.deleteData('password');
    Get.offAllNamed('/login');
  }
}
