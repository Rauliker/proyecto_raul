import 'package:bidhub/domain/entities/availability.dart';

class AvailabilityModel extends AvailabilityEntity {
  AvailabilityModel({
    required super.monday,
    required super.tuesday,
    required super.wednesday,
    required super.thursday,
    required super.friday,
    required super.saturday,
    required super.sunday,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      monday: List<String>.from(json['monday']),
      tuesday: List<String>.from(json['tuesday']),
      wednesday: List<String>.from(json['wednesday']),
      thursday: List<String>.from(json['thursday']),
      friday: List<String>.from(json['friday']),
      saturday: List<String>.from(json['saturday']),
      sunday: List<String>.from(json['sunday']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };
  }
}
