import 'package:bidhub/data/models/court_model.dart';
import 'package:bidhub/domain/entities/reservation.dart';

class ReservationModel extends ReservationEntity {
  ReservationModel({
    required super.id,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.createdAt,
    required super.updatedAt,
    required super.status,
    super.court,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      status: json['status'] ?? '',
      court: json['court'] != null ? PistaModel.fromJson(json['court']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
      'court': court != null ? (court as PistaModel).toJson() : null,
    };
  }
}
