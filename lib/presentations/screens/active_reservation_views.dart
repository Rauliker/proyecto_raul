import 'package:bidhub/core/values/colors.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/get_all_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/get_all_reservation_state.dart';
import 'package:bidhub/presentations/controllers/actives_reservaton_controllers.dart';
import 'package:bidhub/presentations/controllers/user_menu_controller.dart';
import 'package:bidhub/presentations/global_widgets/custom_medium_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveReservationView extends StatefulWidget {
  const ActiveReservationView({super.key});

  @override
  State<ActiveReservationView> createState() => _ActiveReservationViewState();
}

class _ActiveReservationViewState extends State<ActiveReservationView> {
  late ReservationController _controller;
  late UpdateUserMenuController controllerToken;
  late bool hasToken = false;

  late List<bool> _isExpandedList;

  @override
  void initState() {
    super.initState();
    controllerToken = UpdateUserMenuController(context);
    controllerToken.onInit();

    controllerToken.checkToken().then((value) {
      setState(() {
        hasToken = value;
      });
    });

    _controller = ReservationController(context);
    _controller.initialize("actives");
    _isExpandedList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservas Activas",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: MultiBlocListener(
          listeners: _controller.buildBlocListeners(),
          child: Column(
            children: [
              Expanded(
                child:
                    BlocBuilder<GetAllReservationBloc, GetAllReservationState>(
                  builder: (context, state) {
                    if (state is GetAllReservationLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetAllReservationSuccess) {
                      if (state.message.isEmpty) {
                        return const Center(
                            child: Text("No hay reservas disponibles"));
                      }

                      if (_isExpandedList.length != state.message.length) {
                        _isExpandedList = List.generate(
                            state.message.length, (index) => false);
                      }

                      return ListView.builder(
                        itemCount: state.message.length,
                        itemBuilder: (context, index) {
                          final reservation = state.message[index];
                          final int price = _controller.calculatePrice(
                              reservation.court!.price,
                              reservation.startTime,
                              reservation.endTime);

                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(reservation.court!.name),
                                  subtitle: Text("Precio: ${price}€"),
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
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child:
                                                  reservation.court?.imageUrl !=
                                                          null
                                                      ? Image.network(
                                                          _controller
                                                              .getCourtImageUrl(
                                                                  reservation
                                                                      .court
                                                                      ?.imageUrl),
                                                          width: kIsWeb
                                                              ? 150
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                          height: kIsWeb
                                                              ? 150
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'assets/hero_onboarding.png',
                                                          width: kIsWeb
                                                              ? 150
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                          height: kIsWeb
                                                              ? 150
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                            const SizedBox(width: 16.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Fecha de reserva \n ${reservation.date} ${reservation.startTime} - ${reservation.endTime}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16.0),
                                        if (reservation?.status == "created")
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: CustomMediumButton(
                                                  color: red,
                                                  label: 'Cancelar',
                                                  onTap: () =>
                                                      _controller.delete(
                                                          context,
                                                          reservation.id),
                                                ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: CustomMediumButton(
                                                  color: const Color.fromRGBO(
                                                      31, 53, 255, 1),
                                                  label:
                                                      'Pagar ${reservation.court!.price}€',
                                                  onTap: () =>
                                                      _controller.payment(
                                                          context,
                                                          reservation.id,
                                                          price),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  )
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
          )),
    );
  }
}
