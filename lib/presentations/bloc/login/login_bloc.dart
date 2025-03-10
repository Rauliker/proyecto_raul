import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/login/login_event.dart';
import 'package:bidhub/presentations/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final CaseLoginUser loginUser;

  LoginBloc(this.loginUser) : super(LoginInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await loginUser(event.email, event.password);
        emit(LoginSuccess(user));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
