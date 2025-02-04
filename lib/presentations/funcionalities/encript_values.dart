import 'package:bidhub/presentations/funcionalities/get_encription_key.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

///  Función para cifrar un valor
Future<String> encryptData(String value) async {
  final encryptionKey = await getEncryptionKey();
  final encrypter = Encrypter(AES(Key.fromUtf8(encryptionKey)));
  final iv = IV.fromLength(16); // IV aleatorio de 16 bytes
  return encrypter.encrypt(value, iv: iv).base64;
}

/// Función para descifrar un valor
Future<String> decryptData(String encryptedValue) async {
  final encryptionKey = await getEncryptionKey();
  final encrypter = Encrypter(AES(Key.fromUtf8(encryptionKey)));
  final iv = IV.fromLength(16);
  return encrypter.decrypt64(encryptedValue, iv: iv);
}

/// Guardar un `String` cifrado en SharedPreferences
Future<void> saveEncryptedString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  final encryptedValue = await encryptData(value);
  await prefs.setString(key, encryptedValue);
}

/// Guardar un `int` cifrado en SharedPreferences
Future<void> saveEncryptedInt(String key, int value) async {
  await saveEncryptedString(key, value.toString());
}

/// Leer un `String` descifrado
Future<String?> readEncryptedString(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final encryptedValue = prefs.getString(key);
  if (encryptedValue == null) return null;
  return await decryptData(encryptedValue);
}

/// Leer un `int` descifrado
Future<int?> readEncryptedInt(String key) async {
  final decryptedString = await readEncryptedString(key);
  if (decryptedString == null) return null;
  return int.tryParse(decryptedString);
}
