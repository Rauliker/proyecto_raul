import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> pay(String secret) async {
  try {
    // Inicializamos la hoja de pago con el secreto proporcionado
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'Test Merchant', // Nombre del comerciante
        paymentIntentClientSecret: secret, // Secreto del intent de pago
        style: ThemeMode.dark, // Estilo de la interfaz (oscuro)
      ),
    );
  } catch (e) {
    print('Error al inicializar la hoja de pago: $e');
  }
}
