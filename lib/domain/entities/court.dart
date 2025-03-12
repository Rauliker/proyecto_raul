import 'package:bidhub/domain/entities/availability.dart';
import 'package:bidhub/domain/entities/court_status.dart';
import 'package:bidhub/domain/entities/court_type.dart';
import 'package:bidhub/domain/entities/reservation.dart';

class PistaEntity {
  final int id;
  final String name;
  final int price;
  final String? imageUrl;
  final AvailabilityEntity availability;
  final PistaTypeEntity? type;
  final PistaStatusEntity? status;
  final List<ReservationEntity>? reservations;

  PistaEntity({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.availability,
    this.type,
    this.status,
    this.reservations,
  });
}
