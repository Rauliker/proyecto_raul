import 'package:bidhub/data/datasources/provincias_datasource.dart';
import 'package:bidhub/domain/entities/provincias.dart';
import 'package:bidhub/domain/repositories/prov_repository.dart';

class ProvRepositoryImpl implements ProvRepository {
  final ProvRemoteDataSource remoteDataSource;

  ProvRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<Prov>> getRepProvInfo() async {
    return await remoteDataSource.getProvsInfo();
  }
}
