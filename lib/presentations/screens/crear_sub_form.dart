import 'package:bidhub/presentations/appbars/default_appbar.dart';
import 'package:bidhub/presentations/widgets/create_sub_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubForm extends StatefulWidget {
  const SubForm({super.key});

  @override
  SubFormState createState() => SubFormState();
}

class SubFormState extends State<SubForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(mesage: AppLocalizations.of(context)!.create_sub),
        body: const MySubCreateBody());
  }
}
