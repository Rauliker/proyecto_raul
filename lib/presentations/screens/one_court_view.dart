import 'package:bidhub/presentations/bloc/getCourt%20copy/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt%20copy/get_one_court_status.dart';
import 'package:bidhub/presentations/controllers/one_court_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class OneCourtOneView extends StatefulWidget {
  const OneCourtOneView({super.key});

  @override
  State<OneCourtOneView> createState() => _OneCourtOneViewState();
}

class _OneCourtOneViewState extends State<OneCourtOneView> {
  late OneCourtController _controller;

  final int id = int.tryParse(Get.parameters['id'] ?? '') ?? 0;

  @override
  void initState() {
    super.initState();
    _controller = OneCourtController(context, id);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dateController.dispose();
    _controller.startTimeController.dispose();
    _controller.endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reserva", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: _controller.buildBlocListeners(),
        child: BlocBuilder<CourtOneBloc, CourtOneState>(
          builder: (context, state) {
            if (state is CourtOneLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CourtOneSuccess) {
              final court = state.courtOne;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          _controller.getCourtImageUrl(court.imageUrl),
                          width: 400,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("Nombre: ${court.name}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Tipo de pista: ${court.type.name}"),
                      Text("Precio por hora: ${court.price}"),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controller.dateController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha',
                          hintText: 'YYYY-MM-DD',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _controller.startTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Hora de inicio',
                          hintText: 'HH:MM',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _controller.endTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Hora de finalización',
                          hintText: 'HH:MM',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: _controller.submitForm,
                          child: const Text("Reservar"),
                        ),
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed("/home");
                          },
                          child: const Text("Cancelar"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is CourtOneFailure) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("No hay información disponible"));
          },
        ),
      ),
    );
  }
}
