import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  late final FlutterSecureStorage _storage;

  SecureStorageService() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      webOptions: WebOptions(
          dbName: 'secureStorage', publicKey: 'flutter_secure_storage_web'),
    );
  }

  // Guardar datos
  Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Leer datos
  Future<String?> readData(String key) async {
    final value = await _storage.read(key: key);
    return value;
  }

  // Eliminar datos
  Future<void> deleteData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Error deleting data: $e');
    }
  }
}
