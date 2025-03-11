import 'package:bidhub/domain/entities/court.dart';
import 'package:bidhub/domain/repositories/court_repository.dart';

class GetAllPista {
  final PistaRepository repository;

  GetAllPista(this.repository);

  Future<List<PistaEntity>> call(int? idType) async {
    List<PistaEntity> courtTypes = await repository.getAll(idType);
    return courtTypes;
  }
}

class GetOnePista {
  final PistaRepository repository;

  GetOnePista(this.repository);

  Future<PistaEntity> call(int id) async {
    PistaEntity courtTypes = await repository.getOne(id);
    return courtTypes;
  }
}
