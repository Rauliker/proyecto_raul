import 'package:bidhub/domain/entities/users.dart';
import 'package:equatable/equatable.dart';

abstract class GetUserState extends Equatable {
  const GetUserState();

  @override
  List<Object?> get props => [];
}

class GetUserInitial extends GetUserState {}

class GetUserLoading extends GetUserState {}

class GetUserSuccess extends GetUserState {
  final User message;

  const GetUserSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class GetUserFailure extends GetUserState {
  final String message;

  const GetUserFailure(this.message);

  @override
  List<Object?> get props => [message];
}
