import 'package:equatable/equatable.dart';

abstract class CourtEvent extends Equatable {
  const CourtEvent();

  @override
  List<Object?> get props => [];
}

class CourtEventRequested extends CourtEvent {
  final int? idType;
  const CourtEventRequested(this.idType);

  @override
  List<Object?> get props => [];
}
