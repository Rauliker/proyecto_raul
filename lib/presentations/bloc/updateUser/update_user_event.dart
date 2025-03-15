import 'package:equatable/equatable.dart';

abstract class UpdateUserEvent extends Equatable {
  const UpdateUserEvent();

  @override
  List<Object?> get props => [];
}

class UpdateUserCreate extends UpdateUserEvent {
  final int id;
  final String username;
  final String name;
  final String phone;
  final String address;

  const UpdateUserCreate({
    required this.id,
    required this.username,
    required this.name,
    required this.phone,
    required this.address,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        name,
        phone,
        address,
      ];
}
