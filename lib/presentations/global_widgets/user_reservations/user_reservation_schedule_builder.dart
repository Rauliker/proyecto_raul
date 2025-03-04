import 'package:bidhub/core/themes/font_themes.dart';
import 'package:bidhub/core/values/colors.dart';
import 'package:flutter/material.dart';

class UserReservationScheduleBuilder extends StatelessWidget {
  const UserReservationScheduleBuilder({
    Key? key,
    required this.date,
  }) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.event_available,
          color: blue,
          size: 20,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          date,
          style: smallText.copyWith(color: blue),
        )
      ],
    );
  }
}
