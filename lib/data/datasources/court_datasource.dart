import 'dart:convert';

import 'package:bidhub/data/datasources/user_datasource.dart';
import 'package:bidhub/data/models/court_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class PistaRemoteDataSource {
  Future<List<PistaModel>> getAll(int? idType);
  Future<PistaModel> getOne(int id);
  Future<String> create(String name, int typeId, String status, double price,
      Map<String, List<String>> availability);
  Future<String> update(String name, int typeId, String status, double price,
      Map<String, List<String>> availability);
}

class PistaRemoteDataSourceImpl implements PistaRemoteDataSource {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  final http.Client client;

  PistaRemoteDataSourceImpl(this.client);

  @override
  Future<String> create(String name, int typeId, String status, double price,
      Map<String, List<String>> availability) async {
    try {
      final body = jsonEncode({
        'name': name,
        'typeId': typeId,
        'status': status,
        'price': price,
        'availability': availability,
      });
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') == null) {
        throw Exception("inicia sesion");
      }
      final headers = {'Content-Type': 'application/json'};
      final token = await prefs.getString('token') ?? '';
      final urlRequest = '$_baseUrl/court';
      final url = Uri.parse(urlRequest);
      final response = await client.post(url, body: body, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 201) {
        return "Pista creada de manera exitosa";
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception(responseBody["message"]);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> update(String name, int typeId, String status, double price,
      Map<String, List<String>> availability) async {
    try {
      final body = jsonEncode({
        'name': name,
        'typeId': typeId,
        'status': status,
        'price': price,
        'availability': availability,
      });
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') == null) {
        throw Exception("inicia sesion");
      }
      final headers = {'Content-Type': 'application/json'};
      final token = await prefs.getString('token') ?? '';
      final int id = int.tryParse(Get.parameters['id'] ?? '') ?? 0;

      final urlRequest = '$_baseUrl/court/$id';
      final url = Uri.parse(urlRequest);
      final response = await client.put(url, body: body, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return "Pista actualizada de manera exitosa";
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception(responseBody["message"]);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PistaModel>> getAll(int? idType) async {
    try {
      final userRemoteDataSource = UserRemoteDataSourceImpl(client);

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') != null) {
        await userRemoteDataSource.autoLogin();
      }

      final headers = {'Content-Type': 'application/json'};
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
        throw Exception('Error al obtener datos  de las pistas.');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }

  @override
  Future<PistaModel> getOne(int id) async {
    try {
      final userRemoteDataSource = UserRemoteDataSourceImpl(client);

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') != null) {
        await userRemoteDataSource.autoLogin();
      }

      final headers = {'Content-Type': 'application/json'};
      final token = await prefs.getString('token') ?? '';
      final urlRequest = '$_baseUrl/court/$id';
      final url = Uri.parse(urlRequest);
      final response = await client.get(url, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final jsonPista = jsonDecode(response.body);
        return PistaModel.fromJson(jsonPista);
      } else {
        throw Exception('Error al obtener datos de la pista.');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }
}
