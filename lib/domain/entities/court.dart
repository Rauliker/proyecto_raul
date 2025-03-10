import 'package:bidhub/domain/entities/availability.dart';
import 'package:bidhub/domain/entities/court_status.dart';
import 'package:bidhub/domain/entities/court_type.dart';

class PistaEntity {
  final int id;
  final String name;
  final String? imageUrl;
  final AvailabilityEntity availability;
  final PistaTypeEntity type;
  final PistaStatusEntity status;

  PistaEntity({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.availability,
    required this.type,
    required this.status,
  });
}
