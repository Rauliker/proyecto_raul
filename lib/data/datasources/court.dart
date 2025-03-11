import 'dart:convert';

import 'package:bidhub/config/secure_storage.dart';
import 'package:bidhub/data/datasources/user_datasource.dart';
import 'package:bidhub/data/models/court_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class PistaRemoteDataSource {
  Future<List<PistaModel>> getAll(int? idType);
}

class PistaRemoteDataSourceImpl implements PistaRemoteDataSource {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  final SecureStorageService _secureStorage = SecureStorageService();

  final http.Client client;

  PistaRemoteDataSourceImpl(this.client);
  @override
  Future<List<PistaModel>> getAll(int? idType) async {
    try {
      final userRemoteDataSource = UserRemoteDataSourceImpl(client);
      await userRemoteDataSource.autoLogin();

      final headers = {'Content-Type': 'application/json'};
      final prefs = await SharedPreferences.getInstance();
      final token = await prefs.getString('token') ?? '';
      final urlRequest =
          idType != null ? '$_baseUrl/court?type=$idType' : '$_baseUrl/court';
      final url = Uri.parse(urlRequest);
      final response = await client.get(url, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final jsonPista = jsonDecode(response.body);
        return (jsonPista as List)
            .map((item) => PistaModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al obtener datos del usuario.');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }
}
