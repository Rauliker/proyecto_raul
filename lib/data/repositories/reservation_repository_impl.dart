import 'package:bidhub/data/datasources/reservation_datasource.dart';
import 'package:bidhub/domain/entities/reservation.dart';
import 'package:bidhub/domain/repositories/reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final ReservationRemoteDataSource remoteDataSource;

  ReservationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<String> create(
      int id, String data, String startTime, String endTime) async {
    return await remoteDataSource.create(id, data, startTime, endTime);
  }

  @override
  Future<List<ReservationEntity>> getAll(String type) async {
    return await remoteDataSource.getAll(type);
  }

  @override
  Future<bool> cancel(int id) async {
    return await remoteDataSource.cancel(id);
  }
}
