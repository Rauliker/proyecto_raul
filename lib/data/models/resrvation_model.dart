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
      id: json['id'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      status: json['status'],
      court: json['court'],
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
      'court': court,
    };
  }
}
