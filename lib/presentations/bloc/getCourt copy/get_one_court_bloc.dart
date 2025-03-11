import 'package:bidhub/domain/usercase/court_usecase.dart';
import 'package:bidhub/presentations/bloc/getCourt%20copy/get_one_court_event.dart';
import 'package:bidhub/presentations/bloc/getCourt%20copy/get_one_court_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourtOneBloc extends Bloc<CourtOneEvent, CourtOneState> {
  final GetOnePista getAllPista;

  CourtOneBloc(this.getAllPista) : super(CourtOneInitial()) {
    on<CourtOneEventRequested>((event, emit) async {
      emit(CourtOneLoading());
      try {
        final user = await getAllPista(event.id);
        emit(CourtOneSuccess(user));
      } catch (e) {
        emit(CourtOneFailure(e.toString()));
      }
    });
  }
}
