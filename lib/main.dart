import 'package:bidhub/config/notifications/notification_service.dart';
import 'package:bidhub/config/routes.dart';
import 'package:bidhub/injection_container.dart' as di;
import 'package:bidhub/presentations/bloc/cancelReservation/cancel_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/createCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/get_all_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_bloc.dart';
import 'package:bidhub/presentations/bloc/language/language_bloc.dart';
import 'package:bidhub/presentations/bloc/login/login_bloc.dart';
import 'package:bidhub/presentations/bloc/payment/payment_bloc.dart';
import 'package:bidhub/presentations/bloc/register/register_bloc.dart';
import 'package:bidhub/presentations/bloc/reservation/reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/theme/theme_bloc.dart';
import 'package:bidhub/presentations/bloc/theme/theme_state.dart';
import 'package:bidhub/presentations/bloc/updateUser/update_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import 'injection_container.dart' as injection_container;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 3));
  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLIC']!;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  await injection_container.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {
  late Locale locale;

  Future<void> setLocale(Locale value) async {
    setState(() {
      locale = value;
    });

    await NotificationService().initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => LanguageBloc()),
        BlocProvider(
          create: (context) => di.sl<PaymentBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<LoginBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<RegisterBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CourtTypeBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CourtBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CancelReservationBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<GetAllReservationBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<GetUserBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<UpdateUserBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CourtOneBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<ReservationBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<CreateCourtBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return GetMaterialApp(
            locale: const Locale('es', 'ES'),
            supportedLocales: const [
              Locale('es', 'ES'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: themeState.currentTheme.getTheme(),
            getPages: routes,
            initialRoute: '/login',
          );
        },
      ),
    );
  }
}
