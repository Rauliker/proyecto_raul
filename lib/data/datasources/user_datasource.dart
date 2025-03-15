import 'dart:convert';

import 'package:bidhub/config/secure_storage.dart';
import 'package:bidhub/data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> updateUser(
    int id,
    String username,
    String name,
    String phone,
    String address,
  );

  Future<UserModel> login(String email, String password);

  Future<UserModel> createUser(String email, String password, String username,
      String name, String phone, String address);
  Future<UserModel> autoLogin();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  final SecureStorageService _secureStorage = SecureStorageService();

  final http.Client client;

  UserRemoteDataSourceImpl(this.client);

  Future<UserModel> getUserInfo() async {
    try {
      return autoLogin();
    } on http.ClientException {
      throw Exception('Error de conexión con el servidor');
    }
  }

  @override
  Future<UserModel> updateUser(int id, String username, String name,
      String phone, String address) async {
    try {
      final url = Uri.parse('$_baseUrl/users/$id');
      final body = jsonEncode({
        'username': username,
        'name': name,
        'phone': phone,
        'adrress': address,
      });
      final prefs = await SharedPreferences.getInstance();

      final token = await prefs.getString('token') ?? '';

      final headers = {'Content-Type': 'application/json'};

      final response = await client.put(url, body: body, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return UserModel.fromJson(jsonResponse);
      } else {
        final jsonResponse = jsonDecode(response.body);
        final errorMessage = jsonResponse['message'] ?? 'Error desconocido';
        throw Exception(errorMessage);
      }
    } on http.ClientException {
      throw Exception('Error de conexión con el servidor');
    }
  }

  Future<UserModel> autoLogin() async {
    try {
      final email = await _secureStorage.readData('email');
      final password = await _secureStorage.readData('password');

      if (email != null && password != null) {
        return await login(email, password);
      } else {
        throw Exception('No se encontraron credenciales guardadas.');
      }
    } catch (e) {
      throw Exception(
          'Error inesperado al intentar iniciar sesión automáticamente: $e');
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final url = Uri.parse('$_baseUrl/users/login');
      final body = jsonEncode({
        'email': email,
        'password': password,
      });

      final headers = {'Content-Type': 'application/json'};

      final response = await client.post(url, body: body, headers: headers);
      final json = jsonDecode(response.body);
      if (response.statusCode == 201) {
        await _secureStorage.saveData('email', email);
        await _secureStorage.saveData('password', password);
        final token = json['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('emailSearch', email);

        final url2 = Uri.parse('$_baseUrl/users');
        final responseUser = await client.get(url2, headers: {
          ...headers,
          'Authorization': 'Bearer $token',
        });

        final jsonUser = jsonDecode(responseUser.body);
        return UserModel.fromJson(jsonUser[0]);
      } else {
        throw Exception('Error al obtener datos del usuario.');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }

  @override
  Future<UserModel> createUser(String email, String password, String username,
      String name, String phone, String address) async {
    try {
      String urlPrase = '$_baseUrl/users';
      final url = Uri.parse(urlPrase);
      final body = jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "username": username,
        "phone": phone,
        "adrress": address
      });

      final headers = {'Content-Type': 'application/json'};

      final response = await client.post(url, body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = response.body;
        final jsonResponse = jsonDecode(responseBody);
        return UserModel.fromJson(jsonResponse);
      } else {
        final responseBody = response.body;
        final jsonResponse = jsonDecode(responseBody);
        final errorMessage = jsonResponse['message'] ?? 'Error desconocido';
        throw Exception(errorMessage);
      }
    } on http.ClientException {
      throw Exception('Error de conexión con el servidor');
    }
  }
}
