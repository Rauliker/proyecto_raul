import 'package:bidhub/presentations/bloc/getUser/get_user_bloc.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_state.dart';
import 'package:bidhub/presentations/controllers/update_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  UpdateUserScreenState createState() => UpdateUserScreenState();
}

class UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();

  late UpdateUserController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UpdateUserController(context);
    _controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info usuario'),
      ),
      body: MultiBlocListener(
        listeners: _controller.buildBlocListeners(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: BlocBuilder<GetUserBloc, GetUserState>(
                builder: (context, state) {
              if (state is GetUserLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetUserSuccess) {
                _controller.id = state.message.id;
                _controller.emailController.text = state.message.email;
                _controller.usernameController.text = state.message.username;
                _controller.fullNameController.text = state.message.name;
                _controller.phoneNumberController.text = state.message.phone;
                _controller.addressController.text = state.message.address;
                _controller.passwordController.text = state.message.password;

                return Column(
                  children: [
                    TextFormField(
                      initialValue: _controller.emailController.text,
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: (value) =>
                          _controller.emailController.text = value,
                      enabled: false,
                    ),
                    TextFormField(
                      initialValue: _controller.usernameController.text,
                      decoration: const InputDecoration(labelText: 'Username'),
                      onChanged: (value) =>
                          _controller.emailController.text = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pon tu nombre de usuario';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _controller.fullNameController.text,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      onChanged: (value) =>
                          _controller.fullNameController.text = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pon tu nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _controller.phoneNumberController.text,
                      decoration: const InputDecoration(labelText: 'Telefono'),
                      onChanged: (value) =>
                          _controller.phoneNumberController.text = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pon un numero de telofono';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _controller.addressController.text,
                      decoration: const InputDecoration(labelText: 'Direccion'),
                      onChanged: (value) =>
                          _controller.addressController.text = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pon una direccoin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _controller.handleUpdateUser(context),
                      child: const Text('Actualizar'),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.offAllNamed('/home'),
                      child: const Text('Volver'),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ),
        ),
      ),
    );
  }
}
