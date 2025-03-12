import 'package:equatable/equatable.dart';

abstract class ReservationEvent extends Equatable {
  const ReservationEvent();

  @override
  List<Object?> get props => [];
}

class ReservationCreate extends ReservationEvent {
  final int id;
  final String data;
  final String startTime;
  final String endTime;

  const ReservationCreate(
      {required this.id,
      required this.data,
      required this.startTime,
      required this.endTime});

  @override
  List<Object?> get props => [id, data, startTime, endTime];
}
