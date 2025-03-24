import 'package:bidhub/domain/entities/availability.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_status.dart';
import 'package:bidhub/presentations/controllers/one_court_controllers.dart';
import 'package:flutter/foundation.dart';
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

  Widget buildAvailabilitySchedule(AvailabilityEntity availability) {
    List<String> daysOfWeek = [
      "Lunes",
      "Martes",
      "Miércoles",
      "Jueves",
      "Viernes",
      "Sábado",
      "Domingo"
    ];

    Map<String, List<String>> availabilityMap = {
      "Lunes": availability.monday,
      "Martes": availability.tuesday,
      "Miércoles": availability.wednesday,
      "Jueves": availability.thursday,
      "Viernes": availability.friday,
      "Sábado": availability.saturday,
      "Domingo": availability.sunday,
    };

    String selectedDay = daysOfWeek.first;

    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: daysOfWeek.map((day) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(day),
                    selected: selectedDay == day,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() => selectedDay = day);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: availabilityMap[selectedDay]!.isNotEmpty
                ? availabilityMap[selectedDay]!
                    .map((hour) => Chip(label: Text(hour)))
                    .toList()
                : [const Text("No hay horarios disponibles")],
          ),
        ],
      ),
    );
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
        child:
            BlocBuilder<CourtOneBloc, CourtOneState>(builder: (context, state) {
          if (state is CourtOneLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourtOneSuccess) {
            final court = state.courtOne;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: court.imageUrl != null
                            ? Image.network(
                                _controller.getCourtImageUrl(court.imageUrl),
                                width: kIsWeb
                                    ? 400
                                    : MediaQuery.of(context).size.width,
                                height: kIsWeb
                                    ? 260
                                    : MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/hero_onboarding.png',
                                width: kIsWeb
                                    ? 400
                                    : MediaQuery.of(context).size.width,
                                height: kIsWeb
                                    ? 260
                                    : MediaQuery.of(context).size.height * 0.2,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text("Nombre: ${court.name}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Tipo de pista: ${court.type?.name}"),
                      Text("Precio por hora: ${court.price}"),
                      const SizedBox(height: 16),
                      buildAvailabilitySchedule(court.availability),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _controller.dateController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha',
                          hintText: 'YYYY-MM-DD',
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            _controller.dateController.text = formattedDate;
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _controller.startTimeController,
                        readOnly: true,
                        decoration:
                            const InputDecoration(labelText: 'Hora de inicio'),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Horas",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _controller
                                .decrementHour(_controller.startTimeController),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _controller
                                .incrementHour(_controller.startTimeController),
                          ),
                          const Text(
                            "Minutos",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _controller.decrementMinutes(
                                _controller.startTimeController),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _controller.incrementMinutes(
                                _controller.startTimeController),
                          ),
                        ],
                      ),
                      TextField(
                        controller: _controller.endTimeController,
                        readOnly: true,
                        decoration:
                            const InputDecoration(labelText: 'Hora de fin'),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Horas",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _controller
                                .decrementHour(_controller.endTimeController),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _controller
                                .incrementHour(_controller.endTimeController),
                          ),
                          const Text(
                            "Minutos",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => _controller.decrementMinutes(
                                _controller.endTimeController),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => _controller.incrementMinutes(
                                _controller.endTimeController),
                          ),
                        ],
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: _controller.submitForm,
                          child: const Text("Reservar"),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed("/home");
                          },
                          child: const Text("Cancelar"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is CourtOneFailure) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No hay información disponible"));
        }),
      ),
    );
  }
}
