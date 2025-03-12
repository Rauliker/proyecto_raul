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
