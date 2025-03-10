import 'package:bidhub/domain/entities/court_type.dart';
import 'package:equatable/equatable.dart';

abstract class CourtTypeState extends Equatable {
  const CourtTypeState();

  @override
  List<Object?> get props => [];
}

class CourtTypeInitial extends CourtTypeState {}

class CourtTypeLoading extends CourtTypeState {}

class CourtTypeSuccess extends CourtTypeState {
  final PistaTypeEntity user;

  const CourtTypeSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class CourtTypeFailure extends CourtTypeState {
  final String message;

  const CourtTypeFailure(this.message);

  @override
  List<Object?> get props => [message];
}
