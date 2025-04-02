import 'package:bidhub/core/values/colors.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_bloc.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_state.dart';
import 'package:bidhub/presentations/controllers/user_menu_controller.dart';
import 'package:bidhub/presentations/global_widgets/custom_medium_button.dart';
import 'package:bidhub/presentations/global_widgets/footer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class UpdateUserMenuScreen extends StatefulWidget {
  const UpdateUserMenuScreen({super.key});

  @override
  State<UpdateUserMenuScreen> createState() => _UpdateUserMenuScreenState();
}

class _UpdateUserMenuScreenState extends State<UpdateUserMenuScreen> {
  final _formKey = GlobalKey<FormState>();

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
                  Form(
                    key: _formKey,
                    child: BlocBuilder<GetUserBloc, GetUserState>(
                        builder: (context, state) {
                      if (state is GetUserLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is GetUserSuccess) {
                        controller.id = state.message.id;
                        controller.emailController.text = state.message.email;
                        controller.usernameController.text =
                            state.message.username;
                        controller.fullNameController.text = state.message.name;
                        controller.phoneNumberController.text =
                            state.message.phone;
                        controller.addressController.text =
                            state.message.address;
                        controller.passwordController.text =
                            state.message.password;

                        return Column(
                          children: [
                            TextFormField(
                              initialValue: controller.emailController.text,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                              onChanged: (value) =>
                                  controller.emailController.text = value,
                              enabled: false,
                            ),
                            TextFormField(
                              initialValue: controller.usernameController.text,
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              onChanged: (value) =>
                                  controller.usernameController.text = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Pon tu nombre de usuario';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: controller.fullNameController.text,
                              decoration:
                                  const InputDecoration(labelText: 'Nombre'),
                              onChanged: (value) =>
                                  controller.fullNameController.text = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Pon tu nombre';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue:
                                  controller.phoneNumberController.text,
                              decoration:
                                  const InputDecoration(labelText: 'Telefono'),
                              onChanged: (value) =>
                                  controller.phoneNumberController.text = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'pon un numero de telofono';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: controller.addressController.text,
                              decoration:
                                  const InputDecoration(labelText: 'Direccion'),
                              onChanged: (value) =>
                                  controller.addressController.text = value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Pon una direccoin';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: CustomMediumButton(
                                color: green,
                                label: 'Actualizar',
                                onTap: () =>
                                    controller.handleUpdateUser(context),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 20)),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
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
