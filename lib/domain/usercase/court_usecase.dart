import 'package:bidhub/domain/entities/court.dart';
import 'package:bidhub/domain/repositories/court_repository.dart';

class GetAllPista {
  final PistaRepository repository;

  GetAllPista(this.repository);

  Future<List<PistaEntity>> call() async {
    List<PistaEntity> courtTypes = await repository.getAll();
    return courtTypes;
  }
}
