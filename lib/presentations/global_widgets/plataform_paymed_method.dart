import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_web/flutter_stripe_web.dart'
    if (dart.library.io) 'package:flutter_stripe/flutter_stripe.dart';
import 'package:web/web.dart' as web if (dart.library.io) 'dart:io';

String getUrlPort() {
  if (kIsWeb) {
    return web.window.location.port;
  } else {
    // En Android o plataformas móviles, no es necesario obtener el puerto de esta manera
    return '';
  }
}

String getReturnUrl() {
  if (kIsWeb) {
    return web.window.location.href;
  } else {
    // Aquí puedes poner la lógica específica para Android si es necesario
    return '';
  }
}

Future<void> pay(String? clientSecret) async {
  if (kIsWeb) {
    await WebStripe.instance.confirmPaymentElement(
      ConfirmPaymentElementOptions(
        confirmParams: ConfirmPaymentParams(return_url: getReturnUrl()),
      ),
    );
  } else {
    // Aquí implementas la lógica de pago para Android o dispositivos móviles
    await Stripe.instance.confirmPayment(paymentIntentClientSecret: clientSecret! );
  }
}
class PlatformPaymentElement extends StatelessWidget {
  const PlatformPaymentElement(this.clientSecret);

  final String? clientSecret;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: PaymentElement(
        autofocus: true,
        enablePostalCode: true,
        onCardChanged: (_) {},
        clientSecret: clientSecret ?? '',
      ),
    );
  }
}
