import 'package:bidhub/domain/entities/court.dart';

abstract class PistaRepository {
  Future<List<PistaEntity>> getAll(int? idType);
  Future<PistaEntity> getOne(int id);
  Future<String> create(String name, int typeId, String status, double price,
      Map<String, List<String>> availability);
  Future<String> update(String name, int typeId, String status, double price,
      Map<String, List<String>> availability);
}
