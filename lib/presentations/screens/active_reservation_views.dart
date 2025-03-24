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

                      if (_isExpandedList.isEmpty) {
                        _isExpandedList = List.generate(
                          state.message.length,
                          (index) => index < _isExpandedList.length
                              ? _isExpandedList[index]
                              : false,
                        );
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
                                        reservation.court?.imageUrl != null
                                            ? Image.network(
                                                _controller.getCourtImageUrl(
                                                    reservation
                                                        .court?.imageUrl),
                                                width: kIsWeb
                                                    ? 400
                                                    : MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                height: kIsWeb
                                                    ? 260
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.2,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/hero_onboarding.png',
                                                width: kIsWeb
                                                    ? 400
                                                    : MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                height: kIsWeb
                                                    ? 260
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.2,
                                                fit: BoxFit.cover,
                                              ),
                                        Text(
                                            "Fecha de reserva ${reservation.date} ${reservation.startTime} - ${reservation.endTime}"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              child: CustomMediumButton(
                                                color: red,
                                                label: 'Reservar',
                                                onTap: () => _controller.delete(
                                                    context, reservation.id),
                                              ),
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
