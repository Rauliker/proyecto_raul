import 'package:bidhub/config/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserMenuController extends GetxController {
  var hasToken = false;
  final SecureStorageService _secureStorage = SecureStorageService();

  UpdateUserMenuController(BuildContext context);

  @override
  void onInit() {
    super.onInit();
    checkToken();
  }

  Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    hasToken = token != null && token.isNotEmpty;
    return hasToken;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await _secureStorage.deleteData('email');
    await _secureStorage.deleteData('password');
    Get.offAllNamed('/login');
  }
}
