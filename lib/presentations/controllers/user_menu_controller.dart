import 'package:bidhub/config/secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserMenuController extends GetxController {
  var hasToken = false.obs;
  final SecureStorageService _secureStorage = SecureStorageService();

  @override
  void onInit() {
    super.onInit();
    _checkToken();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    hasToken.value = token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await _secureStorage.deleteData('email');
    await _secureStorage.deleteData('password');
    Get.offAllNamed('/home');
  }
}
