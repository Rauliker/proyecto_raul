import 'package:bidhub/core/themes/font_themes.dart';
import 'package:bidhub/core/values/colors.dart';
import 'package:flutter/material.dart';

class FooterText extends StatelessWidget {
  const FooterText({
    Key? key,
    required this.label,
    required this.labelWithFunction,
    required this.ontap,
  }) : super(key: key);

  final VoidCallback ontap;
  final String label;
  final String labelWithFunction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: smallText),
        GestureDetector(
          onTap: ontap,
          child: Text(
            labelWithFunction,
            style: smallText.copyWith(color: blue),
          ),
        )
      ],
    );
  }
}
