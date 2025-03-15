import 'package:bidhub/domain/entities/users.dart';
import 'package:equatable/equatable.dart';

abstract class UpdateUserState extends Equatable {
  const UpdateUserState();

  @override
  List<Object?> get props => [];
}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserLoading extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {
  final User message;

  const UpdateUserSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateUserFailure extends UpdateUserState {
  final String message;

  const UpdateUserFailure(this.message);

  @override
  List<Object?> get props => [message];
}
