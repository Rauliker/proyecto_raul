import 'package:bidhub/core/themes/font_themes.dart';
import 'package:flutter/material.dart';

AppBar customWhiteAppBar(String title) {
  return AppBar(
    toolbarHeight: 70,
    elevation: 0,
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    title: Text(
      title,
      style: profileTextStyle,
    ),
    centerTitle: true,
  );
}
