import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/updateUser/update_user_event.dart';
import 'package:bidhub/presentations/bloc/updateUser/update_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UpdateUserInfo updateUser;

  UpdateUserBloc(this.updateUser) : super(UpdateUserInitial()) {
    on<UpdateUserCreate>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        final message = await updateUser(
            event.id, event.username, event.name, event.phone, event.address);
        emit(UpdateUserSuccess(message));
      } catch (e) {
        emit(UpdateUserFailure(e.toString()));
      }
    });
  }
}
