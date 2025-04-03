import 'package:bidhub/domain/entities/reservation.dart';
import 'package:flutter/material.dart';

abstract class ReservationRepository {
  Future<String> create(int id, String data, String startTime, String endTime);
  Future<List<ReservationEntity>> getAll(String type);
  Future<bool> cancel(int id);
  Future<String> payment(BuildContext context, int id, int amount);
}
