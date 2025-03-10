import 'package:bidhub/domain/entities/court_status.dart';

class PistaStatusModel extends PistaStatusEntity {
  PistaStatusModel({required int id, required String name})
      : super(id: id, name: name);

  factory PistaStatusModel.fromJson(Map<String, dynamic> json) {
    return PistaStatusModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
