import 'package:bidhub/data/datasources/court_type.dart';
import 'package:bidhub/domain/entities/court_type.dart';
import 'package:bidhub/domain/repositories/court_type_repository.dart';

class PistaTypeRepositoryImpl implements PistaTypeRepository {
  final PistaTypeRemoteDataSource remoteDataSource;

  PistaTypeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PistaTypeEntity> getAll() async {
    return await remoteDataSource.getAll();
  }
}
