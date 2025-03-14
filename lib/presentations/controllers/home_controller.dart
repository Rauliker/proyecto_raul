import 'package:bidhub/presentations/screens/active_reservation_views.dart';
import 'package:bidhub/presentations/screens/all_court_views.dart';
import 'package:bidhub/presentations/screens/historial_reservation.views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var pageIndex = 0.obs;
  var pageController = PageController(initialPage: 0);
  var bySlide = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  List<Widget> pages = [
    const AllCourtView(),
    const ActiveReservationView(),
    const HistorialReservationView()
  ];

  void changePageBySlide(int index) {
    pageIndex.value = index;
  }

  void changePage(int index) {
    pageController.animateToPage(
      index,
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 170),
    );
    pageIndex.value = index;
  }
}
