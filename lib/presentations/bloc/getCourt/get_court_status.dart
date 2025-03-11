import 'package:bidhub/domain/entities/court.dart';
import 'package:equatable/equatable.dart';

abstract class CourtState extends Equatable {
  const CourtState();

  @override
  List<Object?> get props => [];
}

class CourtInitial extends CourtState {}

class CourtLoading extends CourtState {}

class CourtSuccess extends CourtState {
  final List<PistaEntity> court;

  const CourtSuccess(this.court);

  @override
  List<Object?> get props => [court];
}

class CourtFailure extends CourtState {
  final String message;

  const CourtFailure(this.message);

  @override
  List<Object?> get props => [message];
}
