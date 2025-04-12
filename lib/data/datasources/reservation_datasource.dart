import 'dart:convert';

import 'package:bidhub/data/models/resrvation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class ReservationRemoteDataSource {
  Future<String> create(int id, String data, String startTime, String endTime);
  Future<List<ReservationModel>> getAll(String type);
  Future<bool> cancel(int id);
  Future<String> payment(BuildContext context, int id, int amount);
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
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') == null) {
        throw Exception("inicia sesion");
      }
      final headers = {'Content-Type': 'application/json'};
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
  Future<String> payment(BuildContext context, int id, int amount) async {
    try {
      final body = jsonEncode({
        'id': id,
        'currency': "eur",
        'amount': amount,
      });
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') == null) {
        throw Exception("inicia sesion");
      }
      final headers = {'Content-Type': 'application/json'};
      final token = await prefs.getString('token') ?? '';
      final urlRequest = '$_baseUrl/reservation/payment';
      final url = Uri.parse(urlRequest);
      final response = await client.post(url, body: body, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        final clientSecret = responseBody['clientSecret'];
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            merchantDisplayName: 'Test Merchant', // Nombre del comerciante
            paymentIntentClientSecret:
                clientSecret, // Secreto del intent de pago
            style: ThemeMode.dark, // Estilo de la interfaz (oscuro)
          ),
        );
        await Stripe.instance.presentPaymentSheet();

        return responseBody['clientSecret'];
      } else {
        final responseBody = jsonDecode(response.body);
        throw Exception(responseBody["message"]);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> createPaymentIntent(int id, int amount) async {
    try {
      final body = jsonEncode({
        'id': id,
        'currency': "eur",
        'amount': amount,
      });
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') == null) {
        throw Exception("inicia sesion");
      }
      final headers = {'Content-Type': 'application/json'};
      final token = await prefs.getString('token') ?? '';
      final urlRequest = '$_baseUrl/reservation/payment';
      final url = Uri.parse(urlRequest);
      final response = await client.post(url, body: body, headers: {
        ...headers,
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
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
      final headers = {'Content-Type': 'application/json'};
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token') == null) {
        return [];
      }
      final token = await prefs.getString('token') ?? '';

      final email = await prefs.getString('emailSearch') ?? '';
      final urlRequest = '$_baseUrl/reservation/$type/$email';
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
      final urlRequest = '$_baseUrl/reservation/$id';
      final url = Uri.parse(urlRequest);
      final response = await client.delete(url, headers: {
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
