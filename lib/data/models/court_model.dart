import 'package:bidhub/data/models/availability_model.dart';
import 'package:bidhub/data/models/court_status_model.dart';
import 'package:bidhub/data/models/court_type_model.dart';
import 'package:bidhub/data/models/resrvation_model.dart';
import 'package:bidhub/domain/entities/court.dart';

class PistaModel extends PistaEntity {
  PistaModel({
    required int id,
    required String name,
    required int price,
    String? imageUrl,
    required AvailabilityModel availability,
    List<ReservationModel>? reservations,
    PistaTypeModel? type,
    PistaStatusModel? status,
  }) : super(
          id: id,
          name: name,
          price: price,
          imageUrl: imageUrl,
          availability: availability,
          type: type,
          status: status,
          reservations: reservations,
        );

  factory PistaModel.fromJson(Map<String, dynamic> json) {
    return PistaModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      availability: AvailabilityModel.fromJson(json['availability']),
      type: PistaTypeModel.fromJson(json['type']),
      status: PistaStatusModel.fromJson(json['status']),
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
      'type': (type as PistaTypeModel).toJson(),
      'status': (status as PistaStatusModel).toJson(),
      'reservations': (reservations as List<ReservationModel>?)
          ?.map((e) => e.toJson())
          .toList(),
    };
  }
}
