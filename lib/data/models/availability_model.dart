import 'package:bidhub/domain/entities/availability.dart';

class AvailabilityModel extends AvailabilityEntity {
  AvailabilityModel({
    super.monday,
    super.tuesday,
    super.wednesday,
    super.thursday,
    super.friday,
    super.saturday,
    super.sunday,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      monday: json['monday'] != null ? List<String>.from(json['monday']) : null,
      tuesday:
          json['tuesday'] != null ? List<String>.from(json['tuesday']) : null,
      wednesday: json['wednesday'] != null
          ? List<String>.from(json['wednesday'])
          : null,
      thursday:
          json['thursday'] != null ? List<String>.from(json['thursday']) : null,
      friday: json['friday'] != null ? List<String>.from(json['friday']) : null,
      saturday:
          json['saturday'] != null ? List<String>.from(json['saturday']) : null,
      sunday: json['sunday'] != null ? List<String>.from(json['sunday']) : null,
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
