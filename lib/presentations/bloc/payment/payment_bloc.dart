import 'package:bidhub/domain/usercase/reservation_usecase.dart';
import 'package:bidhub/presentations/bloc/payment/payment_event.dart';
import 'package:bidhub/presentations/bloc/payment/payment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final Payment loginUser;

  PaymentBloc(this.loginUser) : super(PaymentInitial()) {
    on<PaymentRequested>((event, emit) async {
      emit(PaymentLoading());
      try {
        final message = await loginUser(event.id, event.amount);
        emit(PaymentSuccess(message));
      } catch (e) {
        emit(PaymentFailure(e.toString()));
      }
    });
  }
}
