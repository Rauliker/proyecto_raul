import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_raul/domain/usercase/user_usecase.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_event.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_state.dart';

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
