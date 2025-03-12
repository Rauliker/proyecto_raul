import 'package:bidhub/domain/entities/court.dart';

class ReservationEntity {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final String createdAt;
  final String updatedAt;
  final String status;
  final PistaEntity? court;

  ReservationEntity({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.court,
  });
}
