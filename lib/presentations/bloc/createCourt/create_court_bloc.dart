import 'package:bidhub/domain/usercase/court_usecase.dart';
import 'package:bidhub/presentations/bloc/createCourt/create_court_event.dart';
import 'package:bidhub/presentations/bloc/createCourt/create_court_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateCourtBloc extends Bloc<CreateCourtEvent, CreateCourtState> {
  final CreatePista getAllPista;
  final UpdatePista updatePista;

  CreateCourtBloc(this.getAllPista, this.updatePista)
      : super(CreateCourtInitial()) {
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
    on<UpdateCourtEventRequested>((event, emit) async {
      emit(CreateCourtLoading());
      try {
        final user = await updatePista(
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
