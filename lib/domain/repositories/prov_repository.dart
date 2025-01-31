import 'package:bidhub/domain/entities/provincias.dart';

abstract class ProvRepository {
  Future<List<Prov>> getRepProvInfo();
}
