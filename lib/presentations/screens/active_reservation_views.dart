import 'package:bidhub/presentations/bloc/getCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_status.dart';
import 'package:bidhub/presentations/controllers/all_court_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveReservationView extends StatefulWidget {
  const ActiveReservationView({super.key});

  @override
  State<ActiveReservationView> createState() => _ActiveReservationViewState();
}

class _ActiveReservationViewState extends State<ActiveReservationView> {
  late AllCourtController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AllCourtController(context);
    _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Booked Fields", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: _controller.buildBlocListeners(),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<CourtBloc, CourtState>(
                builder: (context, state) {
                  if (state is CourtLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CourtSuccess) {
                    return ListView.builder(
                      itemCount: state.court.length,
                      itemBuilder: (context, index) {
                        final court = state.court[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Booking ID: ${court.id}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(court.name,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                                Text("Rp. ${court.price}",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                                const SizedBox(height: 8),
                                Image.network(
                                  _controller.getCourtImageUrl(court.imageUrl),
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "📅 ${DateTime.now().toLocal().toString().split(' ')[0]}",
                                        style: const TextStyle(fontSize: 14)),
                                    Text("Rp. ${court.price}",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Schedule: 10:00 - 18:00",
                                        style: TextStyle(fontSize: 14)),
                                    ElevatedButton(
                                      onPressed: () => print('Hola'),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: const Text("Cancel",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is CourtFailure) {
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
