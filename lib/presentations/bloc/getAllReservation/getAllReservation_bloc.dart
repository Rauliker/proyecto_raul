import 'package:bidhub/domain/usercase/reservation_usecase.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/getAllReservation_event.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/getAllReservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetAllReservationBloc
    extends Bloc<GetAllReservationEvent, GetAllReservationState> {
  final GetAllReservation getAllReservation;

  GetAllReservationBloc(this.getAllReservation)
      : super(GetAllReservationInitial()) {
    on<GetAllReservationCreate>((event, emit) async {
      emit(GetAllReservationLoading());
      try {
        final message = await getAllReservation(event.type);
        if (event.type == "historial") {
          emit(GetAllReservationHistorialSuccess(message));
        } else {
          emit(GetAllReservationSuccess(message));
        }
      } catch (e) {
        emit(GetAllReservationFailure(e.toString()));
      }
    });
  }
}
