import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/users/users_event.dart';
import 'package:bidhub/presentations/bloc/users/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutUserBloc extends Bloc<UserEvent, UserState> {
  final CaseLogoutUser logout;

  LogoutUserBloc(this.logout) : super(UserInitial()) {
    on<LogoutRequested>((event, emit) async {
      emit(UserLogoutLoading());
      try {
        await logout();
        emit(UserLogoutLoaded());
      } catch (e) {
        emit(UserLogoutError(message: e.toString()));
      }
    });
  }
}
