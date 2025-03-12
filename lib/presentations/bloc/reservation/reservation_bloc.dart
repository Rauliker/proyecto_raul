import 'package:bidhub/domain/usercase/reservation_usecase.dart';
import 'package:bidhub/presentations/bloc/reservation/reservation_event.dart';
import 'package:bidhub/presentations/bloc/reservation/reservation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final CreateReservation createReservation;

  ReservationBloc(this.createReservation) : super(ReservationInitial()) {
    on<ReservationCreate>((event, emit) async {
      emit(ReservationLoading());
      try {
        final message = await createReservation(
            event.id, event.data, event.startTime, event.endTime);
        emit(ReservationSuccess(message));
      } catch (e) {
        emit(ReservationFailure(e.toString()));
      }
    });
  }
}
