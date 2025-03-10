import 'package:bidhub/domain/usercase/court_type_usecase.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_event.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourtTypeBloc extends Bloc<CourtTypeEvent, CourtTypeState> {
  final GetAllPistaType getAllPistaType;

  CourtTypeBloc(this.getAllPistaType) : super(CourtTypeInitial()) {
    on<CourtTypeEventRequested>((event, emit) async {
      emit(CourtTypeLoading());
      try {
        final user = await getAllPistaType();
        emit(CourtTypeSuccess(user));
      } catch (e) {
        emit(CourtTypeFailure(e.toString()));
      }
    });
  }
}
