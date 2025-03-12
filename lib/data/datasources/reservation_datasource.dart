import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class ReservationRemoteDataSource {
  Future<String> create(int id, String data, String startTime, String endTime);
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
}
