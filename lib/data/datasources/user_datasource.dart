import 'dart:convert';

import 'package:bidhub/config/notifications/notification_service.dart';
import 'package:bidhub/data/models/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login(String email, String password, String deviceInfo);

  Future<UserModel> getUserInfo(String email);
  Future<List<UserModel>> getUsersInfo(String email);

  Future<UserModel> createUser(
      String email,
      String password,
      String username,
      int provincia,
      int municipio,
      String calle,
      List<PlatformFile> imagen,
      int role);
  Future<UserModel> updateUserProfile(String email, String username,
      int provincia, int municipio, String calle, List<PlatformFile> imagen);

  Future<UserModel> updateUserPass(String password);
  Future<UserModel> changeBan(bool banned, String email);
  Future<void> logout();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  final http.Client client;

  UserRemoteDataSourceImpl(this.client);
  @override
  Future<UserModel> login(
      String email, String password, String deviceInfo) async {
    try {
      String? fcmToken;
      if (await NotificationService().hasGrantedPermissions() == true) {
        fcmToken = await NotificationService().getToken();
      }

      final url = Uri.parse('$_baseUrl/users/login');
      final body = jsonEncode({
        'email': email,
        'password': password,
        'deviceInfo': deviceInfo,
        'fcmToken': fcmToken,
      });

      final headers = {'Content-Type': 'application/json'};

      final response = await client.post(url, body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        final json = jsonDecode(response.body);
        await prefs.setInt('role', UserModel.fromJson(json).role);
        await prefs.setString('device', deviceInfo);
        return UserModel.fromJson(json);
      } else {
        throw Exception(
            'Error al obtener datos del usuario. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      final device = prefs.getString('device');
      final url = Uri.parse('$_baseUrl/users/logout/$email?device=$device');
      final headers = {'Content-Type': 'application/json'};

      final response = await client.get(url, headers: headers);

      if (response.statusCode != 200) {
        throw Exception(
            'Error al obtener datos del usuario. Código de estado: ${response.statusCode}');
      } else {
        await prefs.remove('email');
        await prefs.remove('role');
        await prefs.remove('device');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }

  @override
  Future<UserModel> createUser(
      String email,
      String password,
      String username,
      int provincia,
      int municipio,
      String calle,
      List<PlatformFile> image,
      int role) async {
    try {
      final url = Uri.parse('$_baseUrl/users');
      final request = http.MultipartRequest('POST', url);
      request.fields['email'] = email;
      request.fields['username'] = username;
      request.fields['password'] = password;
      request.fields['provinciaId'] = provincia.toString();
      request.fields['localidadId'] = municipio.toString();
      request.fields['calle'] = calle;
      request.fields['role'] = role.toString();

      for (var file in image) {
        if (file.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'files',
              file.bytes!,
              filename: file.name,
            ),
          );
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(responseBody);
        return UserModel.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Error al crear el usuario. Código de estado: ${response.statusCode}. Respuesta: $responseBody');
      }
    } catch (e) {
      throw Exception('Error inesperado al crear el usuario: $e');
    }
  }

  @override
  Future<UserModel> getUserInfo(String email) async {
    try {
      final url = Uri.parse('$_baseUrl/users/$email');
      final headers = {'Content-Type': 'application/json'};

      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return UserModel.fromJson(json);
      } else {
        throw Exception(
            'Error al obtener información del usuario. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Error inesperado al obtener información del usuario: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsersInfo(String email) async {
    try {
      final url = Uri.parse('$_baseUrl/users/excpt/$email');
      final headers = {'Content-Type': 'application/json'};

      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> json = jsonDecode(response.body);
        return json.map((item) => UserModel.fromJson(item)).toList();
      } else {
        throw Exception(
            'Error al obtener información del usuario. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Error inesperado al obtener información del usuario: $e');
    }
  }

  @override
  Future<UserModel> updateUserProfile(
    String email,
    String username,
    int provincia,
    int municipio,
    String calle,
    List<PlatformFile> images,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('email');
      if (userEmail == null) {
        throw Exception(
            'No se encontró el email del usuario en SharedPreferences');
      }

      final url = Uri.parse('$_baseUrl/users/$userEmail');

      final request = http.MultipartRequest('PUT', url);

      request.fields['email'] = email;
      request.fields['username'] = username;
      request.fields['provinciaId'] = provincia.toString();
      request.fields['localidadId'] = municipio.toString();
      request.fields['calle'] = calle;

      for (var file in images) {
        if (file.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'files',
              file.bytes!,
              filename: file.name,
            ),
          );
        }
      }
      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        return UserModel.fromJson(jsonResponse);
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception(
            'Error al actualizar el perfil del usuario. Código de estado: ${response.statusCode}. Respuesta: $responseBody');
      }
    } catch (e) {
      throw Exception(
          'Error inesperado al actualizar el perfil del usuario: $e');
    }
  }

  @override
  Future<UserModel> changeBan(
    bool banned,
    String email,
  ) async {
    try {
      final url = Uri.parse('$_baseUrl/users/$email');

      final body = jsonEncode({"banned": banned});

      final headers = {'Content-Type': 'application/json'};
      final response = await client.put(url, body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return UserModel.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Error al actualizar el perfil del usuario. Código de estado: ${response.statusCode}. Respuesta: ${response.body}');
      }
    } catch (e) {
      throw Exception(
          'Error inesperado al actualizar el cambiar el estado del usuario: $e');
    }
  }

  @override
  Future<UserModel> updateUserPass(
    String password,
  ) async {
    try {
      // Obtén el email del usuario almacenado en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('email');
      if (userEmail == null) {
        throw Exception(
            'No se encontró el email del usuario en SharedPreferences');
      }

      // Construye la URL de la solicitud
      final url = Uri.parse('$_baseUrl/users/$userEmail');

      // Crea una solicitud Multipart para enviar datos
      final body = jsonEncode({"email": userEmail, "password": password});

      // Envía la solicitud

      final headers = {'Content-Type': 'application/json'};
      final response = await client.put(url, body: body, headers: headers);

      // Verifica el código de estado de la respuesta
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return UserModel.fromJson(
            jsonResponse); // Convierte la respuesta en un modelo de usuario
      } else {
        throw Exception(
            'Error al actualizar el perfil del usuario. Código de estado: ${response.statusCode}. Respuesta: ${response.body}');
      }
    } catch (e) {
      throw Exception(
          'Error inesperado al actualizar el perfil del usuario: $e');
    }
  }
}
