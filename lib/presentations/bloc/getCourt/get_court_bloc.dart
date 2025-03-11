import 'package:bidhub/domain/usercase/court_usecase.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_event.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourtBloc extends Bloc<CourtEvent, CourtState> {
  final GetAllPista getAllPista;

  CourtBloc(this.getAllPista) : super(CourtInitial()) {
    on<CourtEventRequested>((event, emit) async {
      emit(CourtLoading());
      try {
        final user = await getAllPista(event.idType);
        emit(CourtSuccess(user));
      } catch (e) {
        emit(CourtFailure(e.toString()));
      }
    });
  }
}
