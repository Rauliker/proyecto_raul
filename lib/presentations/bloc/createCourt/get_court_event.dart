import 'package:equatable/equatable.dart';

abstract class CreateCourtEvent extends Equatable {
  const CreateCourtEvent();

  @override
  List<Object?> get props => [];
}

class CreateCourtEventRequested extends CreateCourtEvent {
  final String name;
  final int typeId;
  final String status;
  final double price;
  final Map<String, List<String>> availability;
  const CreateCourtEventRequested({
    required this.name,
    required this.typeId,
    required this.status,
    required this.price,
    required this.availability,
  });

  @override
  List<Object?> get props => [];
}

class UpdateCourtEventRequested extends CreateCourtEvent {
  final String name;
  final int typeId;
  final String status;
  final double price;
  final Map<String, List<String>> availability;
  const UpdateCourtEventRequested({
    required this.name,
    required this.typeId,
    required this.status,
    required this.price,
    required this.availability,
  });

  @override
  List<Object?> get props => [];
}
