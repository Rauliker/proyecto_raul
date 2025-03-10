import 'package:bidhub/domain/entities/court_type.dart';

class PistaTypeModel extends PistaTypeEntity {
  PistaTypeModel({required int id, required String name})
      : super(id: id, name: name);

  factory PistaTypeModel.fromJson(Map<String, dynamic> json) {
    return PistaTypeModel(
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
