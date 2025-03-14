import 'package:bidhub/presentations/bloc/getAllReservation/getAllReservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/getAllReservation_state.dart';
import 'package:bidhub/presentations/controllers/active_reservaton_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveReservationView extends StatefulWidget {
  const ActiveReservationView({super.key});

  @override
  State<ActiveReservationView> createState() => _ActiveReservationViewState();
}

class _ActiveReservationViewState extends State<ActiveReservationView> {
  late ReservationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ReservationController(context);
    _controller.initialize();
  }

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acctivas", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: _controller.buildBlocListeners(),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<GetAllReservationBloc, GetAllReservationState>(
                builder: (context, state) {
                  if (state is GetAllReservationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetAllReservationSuccess) {
                    return ListView.builder(
                      itemCount: state.message.length,
                      itemBuilder: (context, index) {
                        final reservation = state.message[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(reservation.court!.name),
                                subtitle:
                                    Text("Precio: ${reservation.court!.price}"),
                                trailing: IconButton(
                                  icon: Icon(
                                    _isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                ),
                              ),
                              if (_isExpanded)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        _controller.getCourtImageUrl(
                                            reservation.court?.imageUrl),
                                        width: 200,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                          "Fecha de reserva ${reservation.date} ${reservation.startTime} - ${reservation.startTime}"),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => _controller.delete(
                                                context, reservation.id),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red),
                                            child: const Text("Cancelar"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is GetAllReservationFailure) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("No hay pistas disponibles"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
