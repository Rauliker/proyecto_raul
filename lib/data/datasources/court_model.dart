import 'package:bidhub/data/datasources/availability_model.dart';
import 'package:bidhub/data/datasources/court_status_model.dart';
import 'package:bidhub/data/datasources/court_type_model.dart';
import 'package:bidhub/domain/entities/court.dart';

class PistaModel extends PistaEntity {
  PistaModel({
    required int id,
    required String name,
    String? imageUrl,
    required AvailabilityModel availability,
    required PistaTypeModel type,
    required PistaStatusModel status,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          availability: availability,
          type: type,
          status: status,
        );

  factory PistaModel.fromJson(Map<String, dynamic> json) {
    return PistaModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      availability: AvailabilityModel.fromJson(json['availability']),
      type: PistaTypeModel.fromJson(json['type']),
      status: PistaStatusModel.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'availability': (availability as AvailabilityModel).toJson(),
      'type': (type as PistaTypeModel).toJson(),
      'status': (status as PistaStatusModel).toJson(),
    };
  }
}
