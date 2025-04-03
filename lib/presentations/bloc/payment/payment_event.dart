import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class PaymentRequested extends PaymentEvent {
  final BuildContext context;
  final int id;
  final int amount;

  const PaymentRequested(
      {required this.context, required this.id, required this.amount});

  @override
  List<Object?> get props => [id, amount];
}
