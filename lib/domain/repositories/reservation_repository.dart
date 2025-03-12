abstract class ReservationRepository {
  Future<String> create(int id, String data, String startTime, String endTime);
}
