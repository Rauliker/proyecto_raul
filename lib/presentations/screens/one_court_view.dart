import 'package:bidhub/presentations/bloc/getCourt%20copy/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt%20copy/get_one_court_status.dart';
import 'package:bidhub/presentations/controllers/one_court_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OneCourtOneView extends StatefulWidget {
  final int id;
  const OneCourtOneView({super.key, required this.id});

  @override
  State<OneCourtOneView> createState() => _OneCourtOneViewState();
}

class _OneCourtOneViewState extends State<OneCourtOneView> {
  late OneCourtController _controller;
  @override
  void initState() {
    super.initState();
    _controller = OneCourtController(context, widget.id);
    _controller.initialize();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        _controller.getCourtImageUrl(court.imageUrl),
                        width: 200,
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
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Reservar"),
                      ),
                    ),
                  ],
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
