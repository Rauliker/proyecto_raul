import 'package:bidhub/core/values/colors.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_status.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_status.dart';
import 'package:bidhub/presentations/controllers/all_court_controllers.dart';
import 'package:bidhub/presentations/global_widgets/custom_medium_button.dart';
import 'package:flutter/foundation.dart';
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
                        return ListTile(
                          title: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                court.imageUrl != null
                                    ? Image.network(
                                        _controller
                                            .getCourtImageUrl(court.imageUrl),
                                        width: kIsWeb
                                            ? 400
                                            : MediaQuery.of(context).size.width,
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
                                            : MediaQuery.of(context).size.width,
                                        height: kIsWeb
                                            ? 260
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                        fit: BoxFit.cover,
                                      ),
                                Text(court.name),
                                Text("Tipo de pista: ${court.type?.name}"),
                                Text("Precio por hora: ${court.price}"),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: CustomMediumButton(
                                    color: blue,
                                    label: 'Reservar',
                                    onTap: () => Get.offAllNamed(
                                        '/court-detail/${court.id}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.offAllNamed('/court-detail/${court.id}');
                          },
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
