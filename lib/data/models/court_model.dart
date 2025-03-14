import 'package:bidhub/data/models/availability_model.dart';
import 'package:bidhub/data/models/court_status_model.dart';
import 'package:bidhub/data/models/court_type_model.dart';
import 'package:bidhub/data/models/resrvation_model.dart';
import 'package:bidhub/domain/entities/court.dart';

class PistaModel extends PistaEntity {
  PistaModel({
    required super.id,
    required super.name,
    required super.price,
    super.imageUrl,
    required AvailabilityModel availability,
    List<ReservationModel>? reservations,
    PistaTypeModel? type,
    PistaStatusModel? status,
  }) : super(
          availability: availability,
          type: type,
          status: status,
          reservations: reservations,
        );

  factory PistaModel.fromJson(Map<String, dynamic> json) {
    return PistaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      imageUrl: json['imageUrl'],
      price: json['price'] ?? 0,
      availability: AvailabilityModel.fromJson(json['availability'] ?? {}),
      type: json['type'] != null ? PistaTypeModel.fromJson(json['type']) : null,
      status: json['status'] != null
          ? PistaStatusModel.fromJson(json['status'])
          : null,
      reservations: (json['reservations'] as List<dynamic>?)
          ?.map((e) => ReservationModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'availability': (availability as AvailabilityModel).toJson(),
      'type': type != null ? (type as PistaTypeModel).toJson() : null,
      'status': status != null ? (status as PistaStatusModel).toJson() : null,
      'reservations':
          reservations?.map((e) => (e as ReservationModel).toJson()).toList(),
    };
  }
}
