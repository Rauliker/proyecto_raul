import 'package:equatable/equatable.dart';

abstract class GetAllReservationEvent extends Equatable {
  const GetAllReservationEvent();

  @override
  List<Object?> get props => [];
}

class GetAllReservationCreate extends GetAllReservationEvent {
  final String type;

  const GetAllReservationCreate({required this.type});

  @override
  List<Object?> get props => [type];
}
