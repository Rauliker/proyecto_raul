import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/users/users_event.dart';
import 'package:bidhub/presentations/bloc/users/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final CaseUser loginUser;
  final CaseUserInfo userInfo;
  final CreateUser createUser;
  final CaseUseUserUpdateProfile updateUserProfile;
  final CaseUserUpdatePass updateUserPrass;

  UserBloc(this.loginUser, this.userInfo, this.createUser,
      this.updateUserProfile, this.updateUserPrass)
      : super(UserInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await loginUser(event.email, event.password);
        emit(LoginSuccess(user));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<UserDataRequest>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userInfo(event.email);
        emit(UserLoaded(user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });
    on<UserCreateRequest>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await createUser(
            event.email,
            event.password,
            event.username,
            event.idprovincia,
            event.idmunicipio,
            event.calle,
            event.role,
            event.imagen);
        emit(SignupSuccess(user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });
    on<UserUpdateProfile>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await updateUserProfile(event.email, event.username,
            event.idprovincia, event.idmunicipio, event.calle, event.imagen);
        emit(SignupSuccess(user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });
    on<UserUpdatePass>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await updateUserPrass(event.password);
        emit(SignupSuccess(user));
      } catch (e) {
        emit(UserError(message: e.toString()));
      }
    });
  }
}
