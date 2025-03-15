import 'package:bidhub/domain/entities/reservation.dart';
import 'package:equatable/equatable.dart';

abstract class GetAllReservationState extends Equatable {
  const GetAllReservationState();

  @override
  List<Object?> get props => [];
}

class GetAllReservationInitial extends GetAllReservationState {}

class GetAllReservationLoading extends GetAllReservationState {}

class GetAllReservationSuccess extends GetAllReservationState {
  final List<ReservationEntity> message;

  const GetAllReservationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class GetAllReservationHistorialSuccess extends GetAllReservationState {
  final List<ReservationEntity> message;

  const GetAllReservationHistorialSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class GetAllReservationFailure extends GetAllReservationState {
  final String message;

  const GetAllReservationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
