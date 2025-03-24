import 'package:bidhub/presentations/controllers/user_menu_controller.dart';
import 'package:bidhub/presentations/global_widgets/footer_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateUserMenuScreen extends StatelessWidget {
  const UpdateUserMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateUserMenuController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info user'),
      ),
      body: Center(
        child: controller.hasToken.value
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/update');
                    },
                    child: const Text('Actualizar datos de usuario'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.logout(),
                    child: const Text('Cerrar sesión'),
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
