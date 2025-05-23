import 'package:bidhub/core/themes/custom_snackbar_theme.dart';
import 'package:bidhub/presentations/bloc/createCourt/create_court_bloc.dart';
import 'package:bidhub/presentations/bloc/createCourt/create_court_event.dart';
import 'package:bidhub/presentations/bloc/createCourt/create_court_status.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_event.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CrearPistaForm extends StatefulWidget {
  const CrearPistaForm({super.key});

  @override
  State<CrearPistaForm> createState() => _CrearPistaFormState();
}

class _CrearPistaFormState extends State<CrearPistaForm> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  int? typeId;
  String? status;
  double? price;

  final List<String> days = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  final Map<String, List<TextEditingController>> availabilityControllers = {};
  void _fetchCourtTypeData() {
    final courtTypeBloc = context.read<CourtTypeBloc>();
    if (!courtTypeBloc.isClosed) {
      courtTypeBloc.add(const CourtTypeEventRequested());
    } else {
      context.read<CourtTypeBloc>().add(const CourtTypeEventRequested());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCourtTypeData();
    for (var day in days) {
      availabilityControllers[day] = [
        TextEditingController(),
        TextEditingController()
      ];
    }
  }

  @override
  void dispose() {
    for (var controllers in availabilityControllers.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _guardarFormulario() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final availability = <String, List<String>>{};
      for (var day in days) {
        final slot1 = availabilityControllers[day]![0].text;
        final slot2 = availabilityControllers[day]![1].text;
        availability[day] = [slot1, slot2];
      }

      final pista = {
        'name': name,
        'typeId': typeId,
        'statusId': status,
        'price': price,
        'availability': availability,
      };

      final createBloc = BlocProvider.of<CreateCourtBloc>(context);
      createBloc.add(CreateCourtEventRequested(
        name: name,
        typeId: typeId!,
        status: status!,
        price: price!,
        availability: availability,
      ));

      int i = 0;
      createBloc.stream.listen((state) {
        if (state is CreateCourtFailure) {
          if (i == 0) {
            CustomSnackbar.failedSnackbar(
              title: 'Failed',
              message: state.message.replaceAll('Exception:', ''),
            );
          }
          return;
        } else if (state is CreateCourtSuccess) {
          Get.offAllNamed('/admin');
          if (i == 0) {
            CustomSnackbar.successSnackbar(
              title: 'Success',
              message: 'Registro Correcto',
            );
            i++;
          }
          return;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pista creada correctamente')),
      );
    }
  }

  Widget _buildAvailabilityInputs(String day) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(day[0].toUpperCase() + day.substring(1),
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: availabilityControllers[day]![0],
                decoration:
                    const InputDecoration(labelText: 'Franja 1 (HH:MM-HH:MM)'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: availabilityControllers[day]![1],
                decoration:
                    const InputDecoration(labelText: 'Franja 2 (HH:MM-HH:MM)'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Pista')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Nombre de la pista'),
                onSaved: (value) => name = value ?? '',
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              BlocBuilder<CourtTypeBloc, CourtTypeState>(
                builder: (context, state) {
                  if (state is CourtTypeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CourtTypeSuccess) {
                    return DropdownButtonFormField<int>(
                      decoration:
                          const InputDecoration(labelText: 'Tipo de pista'),
                      value: typeId,
                      items: state.courtType.map((type) {
                        return DropdownMenuItem<int>(
                          value: type.id,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => typeId = value);
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione un tipo' : null,
                    );
                  } else if (state is CourtTypeFailure) {
                    return Center(child: Text("Error: ${state.message}"));
                  }
                  return const Center(
                      child: Text("No hay tipos de pistas disponibles"));
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Estado'),
                items: const [
                  DropdownMenuItem(value: "open", child: Text('Abierta')),
                  DropdownMenuItem(value: "closed", child: Text('Cerrado')),
                ],
                onChanged: (value) => status = value,
                onSaved: (value) => status = value,
                validator: (value) =>
                    value == null ? 'Seleccione un estado' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = double.tryParse(value ?? ''),
                validator: (value) => value!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              const Text('Disponibilidad por día',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...days.map(_buildAvailabilityInputs),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarFormulario,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
