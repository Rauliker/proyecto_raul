import 'package:bidhub/core/themes/custom_snackbar_theme.dart';
import 'package:bidhub/presentations/bloc/getCourt%20copy/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt%20copy/get_one_court_event.dart';
import 'package:bidhub/presentations/bloc/getCourt%20copy/get_one_court_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OneCourtController {
  final BuildContext context;
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  String? selectedCourtType;
  int id;

  // Controladores para el formulario
  final TextEditingController dateController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  OneCourtController(this.context, this.id);

  void initialize() {
    selectedCourtType = 'Todos';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCourtData(id);
    });
  }

  void _fetchCourtData(int id) {
    context.read<CourtOneBloc>().add(CourtOneEventRequested(id));
  }

  List<BlocListener> buildBlocListeners() {
    return [
      BlocListener<CourtOneBloc, CourtOneState>(
        listener: (context, state) {
          if (state is CourtOneFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    ];
  }

  String getCourtImageUrl(String? imageUrl) {
    return imageUrl != null
        ? Uri.parse("$_baseUrl$imageUrl").toString()
        : 'assets/hero_onboarding.png';
  }

  // Lógica de validación y envío del formulario
  void submitForm() {
    // Validar que todos los campos estén completos
    if (dateController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    // Obtener la fecha actual
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Convertir la fecha ingresada en el formulario a DateTime
    final selectedDate = DateTime.parse(dateController.text);

    // Validar que la fecha seleccionada no sea anterior a la fecha actual
    if (selectedDate.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No se puede reservar para una fecha pasada')),
      );
      return;
    }

    // Validar que la fecha seleccionada no sea más de un día después de la fecha actual
    final maxAllowedDate = today.add(const Duration(days: 1));
    if (selectedDate.isAfter(maxAllowedDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('No se puede reservar para más de un día después de hoy')),
      );
      return;
    }
    final courtBloc = BlocProvider.of<CourtOneBloc>(context);
    courtBloc.stream.listen((state) {
      if (state is CourtOneSuccess) {
        if (state.courtOne.availability.monday == null) {
          CustomSnackbar.failedSnackbar(
            title: 'Failed',
            message: 'No hay horas disponibles para esta fecha',
          );
          return;
        }
      }
    });

    // Si pasa todas las validaciones, proceder con el envío del formulario
    final date = dateController.text;
    final startTime = startTimeController.text;
    final endTime = endTimeController.text;

    print(date);
    print(startTime);
    print(endTime);

    // Aquí puedes manejar la lógica de envío del formulario
    // Por ejemplo, enviar los datos a un servidor o almacenarlos localmente
    // Sin imprimir en la consola
  }
}
