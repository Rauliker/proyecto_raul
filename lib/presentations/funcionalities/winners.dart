import 'package:bidhub/domain/entities/subastas_entities.dart';

String winners(List<Puja>? pujas) {
  if (pujas == null || pujas.isEmpty) {
    return 'no winner';
  }

  final Puja latestPuja = pujas.firstWhere((subasta) {
    final winner = subasta.iswinner == true;
    return winner;
  });

  return latestPuja.emailUser;
}
