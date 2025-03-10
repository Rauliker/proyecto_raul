import 'package:bidhub/presentations/screens/views/all_court.views.dart';
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
