import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/register/register_event.dart';
import 'package:bidhub/presentations/bloc/register/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final CreateUser registerUser;

  RegisterBloc(this.registerUser) : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(RegisterLoading());
      try {
        final user = await registerUser(event.email, event.password,
            event.address, event.name, event.username, event.phone);
        emit(RegisterSuccess(user));
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}
