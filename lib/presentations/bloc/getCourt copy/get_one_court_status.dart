import 'package:bidhub/domain/entities/court.dart';
import 'package:equatable/equatable.dart';

abstract class CourtOneState extends Equatable {
  const CourtOneState();

  @override
  List<Object?> get props => [];
}

class CourtOneInitial extends CourtOneState {}

class CourtOneLoading extends CourtOneState {}

class CourtOneSuccess extends CourtOneState {
  final PistaEntity courtOne;

  const CourtOneSuccess(this.courtOne);

  @override
  List<Object?> get props => [courtOne];
}

class CourtOneFailure extends CourtOneState {
  final String message;

  const CourtOneFailure(this.message);

  @override
  List<Object?> get props => [message];
}
