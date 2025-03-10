import 'dart:convert';

import 'package:bidhub/config/secure_storage.dart';
import 'package:bidhub/data/models/court_type_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class PistaTypeRemoteDataSource {
  Future<List<PistaTypeModel>> getAll();
}

class PistaTypeRemoteDataSourceImpl implements PistaTypeRemoteDataSource {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  final SecureStorageService _secureStorage = SecureStorageService();

  final http.Client client;

  PistaTypeRemoteDataSourceImpl(this.client);
  @override
  Future<List<PistaTypeModel>> getAll() async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final prefs = await SharedPreferences.getInstance();
      final token = await prefs.getString('token') ?? '';
      final url = Uri.parse('$_baseUrl/court-type');
      final response = await client.get(url, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final jsonPista = jsonDecode(response.body);
        return (jsonPista as List)
            .map((item) => PistaTypeModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al obtener datos del usuario.');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }
}
