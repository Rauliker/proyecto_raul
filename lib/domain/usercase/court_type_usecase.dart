import 'package:bidhub/domain/entities/court_type.dart';
import 'package:bidhub/domain/repositories/court_type_repository.dart';

class GetAllPistaType {
  final PistaTypeRepository repository;

  GetAllPistaType(this.repository);

  Future<List<PistaTypeEntity>> call() async {
    List<PistaTypeEntity> courtTypes = await repository.getAll();
    return courtTypes;
  }
}
