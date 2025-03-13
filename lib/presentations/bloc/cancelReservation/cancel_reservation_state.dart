import 'package:equatable/equatable.dart';

abstract class CancelReservationState extends Equatable {
  const CancelReservationState();

  @override
  List<Object?> get props => [];
}

class CancelReservationInitial extends CancelReservationState {}

class CancelReservationLoading extends CancelReservationState {}

class CancelReservationSuccess extends CancelReservationState {
  final bool message;

  const CancelReservationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CancelReservationFailure extends CancelReservationState {
  final String message;

  const CancelReservationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
