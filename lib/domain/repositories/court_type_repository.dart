import 'package:bidhub/domain/entities/court_type.dart';

abstract class PistaTypeRepository {
  Future<PistaTypeEntity> getAll();
}
