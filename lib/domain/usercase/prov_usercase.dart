import 'package:bidhub/domain/entities/provincias.dart';
import 'package:bidhub/domain/repositories/prov_repository.dart';

class CaseProvInfo {
  final ProvRepository repository;

  CaseProvInfo(this.repository);

  Future<List<Prov>> call() async {
    List<Prov> provInfo = await repository.getRepProvInfo();
    return provInfo;
  }
}
