import 'package:bidhub/presentations/bloc/getUser/get_user_bloc.dart';
import 'package:bidhub/presentations/bloc/getUser/get_user_state.dart';
import 'package:bidhub/presentations/controllers/update_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  UpdateUserScreenState createState() => UpdateUserScreenState();
}

class UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String username = '';
  String name = '';
  String phone = '';

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
        title: const Text('Info user'),
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
                return Column(
                  children: [
                    TextFormField(
                      initialValue: email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: (value) => email = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: username,
                      decoration: const InputDecoration(labelText: 'Username'),
                      onChanged: (value) => username = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (value) => name = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: phone,
                      decoration: const InputDecoration(labelText: 'Phone'),
                      onChanged: (value) => phone = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Update'),
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
