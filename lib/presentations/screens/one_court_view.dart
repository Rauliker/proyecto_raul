import 'package:bidhub/core/values/colors.dart';
import 'package:bidhub/domain/entities/availability.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_status.dart';
import 'package:bidhub/presentations/controllers/one_court_controllers.dart';
import 'package:bidhub/presentations/global_widgets/custom_medium_button.dart';
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
  List<String> daysOfWeek = [
    "Lunes",
    "Martes",
    "Miércoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];

  late String selectedDay;

  @override
  void initState() {
    super.initState();
    _controller = OneCourtController(context, id);
    _controller.initialize();
    selectedDay = DateTime.now().weekday == 7
        ? daysOfWeek[0]
        : daysOfWeek[DateTime.now().weekday - 1];
  }

  @override
  void dispose() {
    _controller.dateController.dispose();
    _controller.startTimeController.dispose();
    _controller.endTimeController.dispose();
    super.dispose();
  }

  Widget buildAvailabilitySchedule(AvailabilityEntity availability) {
    Map<String, List<String>> availabilityMap = {
      "Lunes": availability.monday,
      "Martes": availability.tuesday,
      "Miércoles": availability.wednesday,
      "Jueves": availability.thursday,
      "Viernes": availability.friday,
      "Sábado": availability.saturday,
      "Domingo": availability.sunday,
    };
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
                    .map((hour) => GestureDetector(
                          onTap: () {
                            _controller.fetchDataForm(data: hour);
                          },
                          child: Chip(label: Text(hour)),
                        ))
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
                      const SizedBox(height: 16),
                      Text("Nombre: ${court.name}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Tipo de pista: ${court.type?.name}"),
                      Text("Precio por hora: ${court.price}"),
                      const SizedBox(height: 16),
                      const Text("Horario"),
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
                            initialDate:
                                _controller.dateController.text.isNotEmpty
                                    ? DateTime.parse(
                                        _controller.dateController.text)
                                    : DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                            locale: const Locale('es', 'ES'),
                          );

                          if (pickedDate != null) {
                            String formattedDate =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            _controller.dateController.text = formattedDate;
                            setState(() {
                              selectedDay =
                                  daysOfWeek[pickedDate.weekday % 7 - 1];
                            });
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
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: CustomMediumButton(
                            color: green,
                            label: 'Reservar',
                            onTap: () => _controller.submitForm(),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: CustomMediumButton(
                            color: red,
                            label: 'Atras',
                            onTap: () => Get.offAllNamed("/home"),
                          ),
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
