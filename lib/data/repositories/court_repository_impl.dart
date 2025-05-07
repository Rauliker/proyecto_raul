import 'package:bidhub/data/datasources/court_datasource.dart';
import 'package:bidhub/domain/entities/court.dart';
import 'package:bidhub/domain/repositories/court_repository.dart';

class PistaRepositoryImpl implements PistaRepository {
  final PistaRemoteDataSource remoteDataSource;

  PistaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PistaEntity>> getAll(int? idType) async {
    return await remoteDataSource.getAll(idType);
  }

  @override
  Future<PistaEntity> getOne(int id) async {
    return await remoteDataSource.getOne(id);
  }

  @override
  Future<String> create(String name, int typeId, String status, double price,
      Map<String, List<String>> availability) async {
    return await remoteDataSource.create(
        name, typeId, status, price, availability);
  }
}
