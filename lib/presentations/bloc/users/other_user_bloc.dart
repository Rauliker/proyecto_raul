import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/users/users_event.dart';
import 'package:bidhub/presentations/bloc/users/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherUserBloc extends Bloc<UserEvent, UserState> {
  final CaseUsersInfo userOtherInfo;

  OtherUserBloc(this.userOtherInfo) : super(UserInitial()) {
    on<UserOtherDataRequest>((event, emit) async {
      emit(UserOtherLoading());
      try {
        final user = await userOtherInfo(event.email);
        emit(UserOtherLoaded(user));
      } catch (e) {
        emit(UserOtherError(message: e.toString()));
      }
    });
  }
}
