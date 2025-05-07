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
  const CreateCourtEventRequested(
      this.typeId, this.name, this.status, this.price, this.availability);

  @override
  List<Object?> get props => [];
}
