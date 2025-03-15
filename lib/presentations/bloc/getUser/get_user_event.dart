import 'package:equatable/equatable.dart';

abstract class GetUserEvent extends Equatable {
  const GetUserEvent();

  @override
  List<Object?> get props => [];
}

class GetUserCreate extends GetUserEvent {
  const GetUserCreate();

  @override
  List<Object?> get props => [];
}
