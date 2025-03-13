import 'dart:convert';

import 'package:bidhub/data/datasources/user_datasource.dart';
import 'package:bidhub/data/models/resrvation_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class ReservationRemoteDataSource {
  Future<String> create(int id, String data, String startTime, String endTime);
  Future<List<ReservationModel>> getAll(String type);
  Future<bool> cancel(int id);
}

class ReservationRemoteDataSourceImpl implements ReservationRemoteDataSource {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  final http.Client client;

  ReservationRemoteDataSourceImpl(this.client);
  @override
  Future<String> create(
      int id, String data, String startTime, String endTime) async {
    try {
      final body = jsonEncode({
        'courtId': id,
        'date': data,
        'startTime': startTime,
        'endTime': endTime,
        "status": "created"
      });
      final headers = {'Content-Type': 'application/json'};
      final prefs = await SharedPreferences.getInstance();
      final token = await prefs.getString('token') ?? '';
      final urlRequest = '$_baseUrl/reservation';
      final url = Uri.parse(urlRequest);
      final response = await client.post(url, body: body, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 201) {
        return "Reserva Creada de manera exitosa";
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception(responseBody["message"]);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<ReservationModel>> getAll(String type) async {
    try {
      final userRemoteDataSource = UserRemoteDataSourceImpl(client);
      await userRemoteDataSource.autoLogin();

      final headers = {'Content-Type': 'application/json'};
      final prefs = await SharedPreferences.getInstance();
      final token = await prefs.getString('token') ?? '';

      final email = await prefs.getString('emailSearch') ?? '';
      final urlRequest = '$_baseUrl/$type/$email';
      final url = Uri.parse(urlRequest);
      final response = await client.get(url, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final jsonPista = jsonDecode(response.body);
        return (jsonPista as List)
            .map((item) => ReservationModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al obtener datos  de las pistas.');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }

  @override
  Future<bool> cancel(int id) async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final prefs = await SharedPreferences.getInstance();
      final token = await prefs.getString('token') ?? '';
      final urlRequest = '$_baseUrl/$id';
      final url = Uri.parse(urlRequest);
      final response = await client.get(url, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al obtener datos  de las pistas.');
      }
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }
}
