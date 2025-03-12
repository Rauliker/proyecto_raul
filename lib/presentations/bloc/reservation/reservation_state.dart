import 'package:equatable/equatable.dart';

abstract class ReservationState extends Equatable {
  const ReservationState();

  @override
  List<Object?> get props => [];
}

class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationSuccess extends ReservationState {
  final String message;

  const ReservationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ReservationFailure extends ReservationState {
  final String message;

  const ReservationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
