import 'package:bidhub/domain/usercase/user_usecase.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_event.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  final GetUserInfo getUser;

  GetUserBloc(this.getUser) : super(GetUserInitial()) {
    on<GetUserCreate>((event, emit) async {
      emit(GetUserLoading());
      try {
        final message = await getUser();
        emit(GetUserSuccess(message));
      } catch (e) {
        emit(GetUserFailure(e.toString()));
      }
    });
  }
}
