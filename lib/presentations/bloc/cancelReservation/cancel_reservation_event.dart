import 'package:equatable/equatable.dart';

abstract class CancelReservationEvent extends Equatable {
  const CancelReservationEvent();

  @override
  List<Object?> get props => [];
}

class CancelReservationCreate extends CancelReservationEvent {
  final int id;

  const CancelReservationCreate({required this.id});

  @override
  List<Object?> get props => [id];
}
