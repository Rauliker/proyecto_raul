import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentRequested extends PaymentEvent {
  final int id;
  final int amount;

  const PaymentRequested({required this.id, required this.amount});

  @override
  List<Object?> get props => [id, amount];
}

class LogoutRequested extends PaymentEvent {
  const LogoutRequested();

  @override
  List<Object?> get props => [];
}
