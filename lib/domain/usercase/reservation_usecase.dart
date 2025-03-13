import 'package:bidhub/domain/entities/reservation.dart';
import 'package:bidhub/domain/repositories/reservation_repository.dart';

class CreateReservation {
  final ReservationRepository repository;

  CreateReservation(this.repository);

  Future<String> call(
      int id, String data, String startTime, String endTime) async {
    String courtTypes = await repository.create(id, data, startTime, endTime);
    return courtTypes;
  }
}

class GetAllReservation {
  final ReservationRepository repository;

  GetAllReservation(this.repository);

  Future<List<ReservationEntity>> call(String type) async {
    List<ReservationEntity> court = await repository.getAll(type);
    return court;
  }
}

class CancelReservation {
  final ReservationRepository repository;

  CancelReservation(this.repository);

  Future<bool> call(int id) async {
    bool court = await repository.cancel(id);
    return court;
  }
}
