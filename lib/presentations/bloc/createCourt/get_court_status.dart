import 'package:equatable/equatable.dart';

abstract class CreateCourtState extends Equatable {
  const CreateCourtState();

  @override
  List<Object?> get props => [];
}

class CreateCourtInitial extends CreateCourtState {}

class CreateCourtLoading extends CreateCourtState {}

class CreateCourtSuccess extends CreateCourtState {
  final String court;

  const CreateCourtSuccess(this.court);

  @override
  List<Object?> get props => [court];
}

class CreateCourtFailure extends CreateCourtState {
  final String message;

  const CreateCourtFailure(this.message);

  @override
  List<Object?> get props => [message];
}
