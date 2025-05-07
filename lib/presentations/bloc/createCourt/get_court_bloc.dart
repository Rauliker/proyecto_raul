import 'package:bidhub/domain/usercase/court_usecase.dart';
import 'package:bidhub/presentations/bloc/createCourt/get_court_event.dart';
import 'package:bidhub/presentations/bloc/createCourt/get_court_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCourtBloc extends Bloc<CreateCourtEvent, CreateCourtState> {
  final CreatePista getAllPista;

  CreateCourtBloc(this.getAllPista) : super(CreateCourtInitial()) {
    on<CreateCourtEventRequested>((event, emit) async {
      emit(CreateCourtLoading());
      try {
        final user = await getAllPista(
          event.name,
          event.typeId,
          event.status,
          event.price,
          event.availability,
        );
        emit(CreateCourtSuccess(user));
      } catch (e) {
        emit(CreateCourtFailure(e.toString()));
      }
    });
  }
}
