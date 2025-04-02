import 'package:bidhub/presentations/bloc/getAllReservation/get_all_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/get_all_reservation_state.dart';
import 'package:bidhub/presentations/controllers/actives_reservaton_controllers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HistorialReservationView extends StatefulWidget {
  const HistorialReservationView({super.key});

  @override
  State<HistorialReservationView> createState() =>
      _HistorialReservationViewState();
}

class _HistorialReservationViewState extends State<HistorialReservationView> {
  late ReservationController _controller;
  late List<bool> _isExpandedList;

  @override
  void initState() {
    super.initState();
    _controller = ReservationController(context);
    _controller.initialize("historial");
    _isExpandedList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: _controller.hasToken.value
          ? Center(
              child: MultiBlocListener(
                listeners: _controller.buildBlocListeners(),
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<GetAllReservationBloc,
                          GetAllReservationState>(
                        builder: (context, state) {
                          if (state is GetAllReservationLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state
                              is GetAllReservationHistorialSuccess) {
                            if (_isExpandedList.isEmpty) {
                              _isExpandedList = List.generate(
                                  state.message.length,
                                  (index) => _isExpandedList.length > index
                                      ? _isExpandedList[index]
                                      : false);
                            }

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
                                        subtitle: Text(
                                            "Precio: ${_controller.calculatePrice(reservation.court!.price, reservation.startTime, reservation.endTime)}€"),
                                        trailing: IconButton(
                                          icon: Icon(
                                            _isExpandedList[index]
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isExpandedList[index] =
                                                  !_isExpandedList[index];
                                            });
                                          },
                                        ),
                                      ),
                                      if (_isExpandedList[index])
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(reservation.court?.status ==
                                                      "confirmed"
                                                  ? "Reservado"
                                                  : reservation.court?.status ==
                                                          "finished"
                                                      ? "Finalizado"
                                                      : "Cancelado"),
                                              reservation.court?.imageUrl !=
                                                      null
                                                  ? Image.network(
                                                      _controller
                                                          .getCourtImageUrl(
                                                              reservation.court
                                                                  ?.imageUrl),
                                                      width: kIsWeb
                                                          ? 400
                                                          : MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                      height: kIsWeb
                                                          ? 260
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      'assets/hero_onboarding.png',
                                                      width: kIsWeb
                                                          ? 400
                                                          : MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                      height: kIsWeb
                                                          ? 260
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      fit: BoxFit.cover,
                                                    ),
                                              Text(
                                                  "Fecha de reserva ${reservation.date} ${reservation.startTime} - ${reservation.endTime}"),
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
                          return const Center(
                              child: Text("No hay reservas disponibles"));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Inicia sesión'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed('/login'),
                  child: const Text('Ir a Login'),
                ),
              ],
            ),
    );
  }
}
