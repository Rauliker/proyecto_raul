import 'package:bidhub/core/values/colors.dart';
import 'package:bidhub/presentations/controllers/user_menu_controller.dart';
import 'package:bidhub/presentations/global_widgets/custom_medium_button.dart';
import 'package:bidhub/presentations/global_widgets/footer_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUserMenuScreen extends StatefulWidget {
  const UpdateUserMenuScreen({super.key});

  @override
  State<UpdateUserMenuScreen> createState() => _UpdateUserMenuScreenState();
}

class _UpdateUserMenuScreenState extends State<UpdateUserMenuScreen> {
  late UpdateUserMenuController controller;
  late bool hasToken = false;
  @override
  void initState() {
    super.initState();
    controller = UpdateUserMenuController(context);
    controller.onInit();

    controller.checkToken().then((value) {
      setState(() {
        hasToken = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info user'),
      ),
      body: Center(
        child: hasToken
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: CustomMediumButton(
                      color: blue,
                      label: 'Actualizar datos de usuario',
                      onTap: () => Get.offAllNamed('/update'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: CustomMediumButton(
                      color: red,
                      label: 'Cerrar sesión',
                      onTap: () => controller.logout(),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FooterText(
                    label: "",
                    labelWithFunction: 'Inicia Sesion',
                    ontap: () => Get.offAllNamed('/login'),
                  ),
                ],
              ),
      ),
    );
  }
}
