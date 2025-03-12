import 'package:equatable/equatable.dart';

abstract class CourtOneEvent extends Equatable {
  const CourtOneEvent();

  @override
  List<Object?> get props => [];
}

class CourtOneEventRequested extends CourtOneEvent {
  final int id;
  const CourtOneEventRequested(this.id);

  @override
  List<Object?> get props => [];
}
