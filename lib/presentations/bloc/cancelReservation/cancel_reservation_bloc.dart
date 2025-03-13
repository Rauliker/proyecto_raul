import 'package:bidhub/domain/usercase/reservation_usecase.dart';
import 'package:bidhub/presentations/bloc/cancelReservation/cancel_reservation_event.dart';
import 'package:bidhub/presentations/bloc/cancelReservation/cancel_reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CancelReservationBloc
    extends Bloc<CancelReservationEvent, CancelReservationState> {
  final CancelReservation getAllReservation;

  CancelReservationBloc(this.getAllReservation)
      : super(CancelReservationInitial()) {
    on<CancelReservationCreate>((event, emit) async {
      emit(CancelReservationLoading());
      try {
        final message = await getAllReservation(event.id);
        emit(CancelReservationSuccess(message));
      } catch (e) {
        emit(CancelReservationFailure(e.toString()));
      }
    });
  }
}
