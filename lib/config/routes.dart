import 'package:bidhub/presentations/screens/home_screen.dart';
import 'package:bidhub/presentations/screens/login_screen.dart';
import 'package:bidhub/presentations/screens/one_court_view.dart';
import 'package:bidhub/presentations/screens/register_screen.dart';
import 'package:get/get.dart';

final List<GetPage> routes = [
  GetPage(
    name: '/login',
    page: () => const LoginPage(),
  ),
  GetPage(
    name: '/register',
    page: () => const RegisterPage(),
  ),
  GetPage(
    name: '/home',
    page: () => const HomePage(),
  ),
  GetPage(
    name: '/court-detail/:id',
    page: () => const OneCourtOneView(),
  ),
];
