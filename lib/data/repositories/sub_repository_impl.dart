import 'package:bidhub/data/datasources/subastas_datasource.dart';
import 'package:bidhub/domain/entities/subastas_entities.dart';
import 'package:bidhub/domain/repositories/sub_repository.dart';
import 'package:file_picker/file_picker.dart';

class SubastasRepositoryImpl implements SubastasRepository {
  final SubastasRemoteDataSource remoteDataSource;

  SubastasRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createSubasta(
    String nombre,
    String descripcion,
    String subInicial,
    String fechaFin,
    String creatorId,
    List<PlatformFile> imagenes,
  ) async {
    await remoteDataSource.createSubasta(
        nombre, descripcion, subInicial, fechaFin, creatorId, imagenes);
  }

  @override
  Future<List<SubastaEntity>> getAllSubastas() async {
    return await remoteDataSource.getAllSubastas();
  }

  @override
  Future<void> deleteSubasta(int id) async {
    await remoteDataSource.deleteSubasta(id);
  }

  @override
  Future<List<SubastaEntity>> getSubastasDeOtroUsuario(String userId,
      String? search, bool? open, int? min, int? max, String? date) async {
    return await remoteDataSource.getSubastasDeOtroUsuario(
        userId, search, open, min, max, date);
  }

  @override
  Future<List<SubastaEntity>> getSubastasPorUsuario(String email) async {
    return await remoteDataSource.getSubastasPorUsuario(email);
  }

  @override
  Future<SubastaEntity> getSubastaById(int id) async {
    return await remoteDataSource.getSubastaById(id);
  }

  @override
  Future<void> updateSubasta(
      int id,
      String nombre,
      String descripcion,
      String fechaFin,
      List<String> eliminatedImages,
      List<PlatformFile> added,
      String pujaInicial) async {
    await remoteDataSource.updateSubasta(id, nombre, descripcion, fechaFin,
        eliminatedImages, added, pujaInicial);
  }

  @override
  Future<void> makePuja(int idPuja, String email, String puja, bool isAuto,
      String incrementController, String maxAutoController) async {
    await remoteDataSource.makePuja(
        idPuja, email, puja, isAuto, incrementController, maxAutoController);
  }
}
