import 'package:bidhub/core/values/colors.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_status.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_status.dart';
import 'package:bidhub/presentations/controllers/all_court_controllers.dart';
import 'package:bidhub/presentations/global_widgets/custom_medium_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AllCourtView extends StatefulWidget {
  const AllCourtView({super.key});

  @override
  State<AllCourtView> createState() => _AllCourtViewState();
}

class _AllCourtViewState extends State<AllCourtView> {
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
        title: const Text("Explora", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: _controller.buildBlocListeners(),
        child: Column(
          children: [
            BlocBuilder<CourtTypeBloc, CourtTypeState>(
              builder: (context, state) {
                if (state is CourtTypeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CourtTypeSuccess) {
                  return Row(
                    children: [
                      Text(
                        "Tipo de pista ${_controller.selectedCourtType ?? "Todos"}",
                        style: const TextStyle(color: Colors.orange),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        hint: const Text("Selecciona el tipo de pista"),
                        value: _controller.selectedCourtType,
                        items: _controller.buildDropdownItems(state),
                        onChanged: (value) {
                          setState(() => _controller.onCourtTypeChanged(value));
                        },
                      ),
                    ],
                  );
                } else if (state is CourtTypeFailure) {
                  return Center(child: Text(state.message));
                }
                return const Center(
                    child: Text("No hay tipos de pistas disponibles"));
              },
            ),
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              court.imageUrl != null
                                  ? Image.network(
                                      _controller
                                          .getCourtImageUrl(court.imageUrl),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/hero_onboarding.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(court.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text("Tipo de pista: ${court.type?.name}"),
                                    Text("Precio por hora: ${court.price}"),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 140,
                                child: CustomMediumButton(
                                  color: blue,
                                  label: 'Reservar',
                                  onTap: () =>
                                      Get.toNamed('/court-detail/${court.id}'),
                                ),
                              ),
                            ],
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
