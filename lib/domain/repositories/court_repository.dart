import 'package:bidhub/domain/entities/court.dart';

abstract class PistaRepository {
  Future<List<PistaEntity>> getAll();
}
