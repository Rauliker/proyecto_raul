import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_event.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_status.dart';
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

  Future<void> submitForm() async {
    // Validar que todos los campos estén completos
    if (dateController.text.isEmpty ||
        startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    // Validar la fecha: formato correcto (YYYY-MM-DD)
    const datePattern = r'^\d{4}-\d{2}-\d{2}$';
    final dateRegex = RegExp(datePattern);
    if (!dateRegex.hasMatch(dateController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, ingrese una fecha válida (YYYY-MM-DD)')),
      );
      return;
    }

    // Obtener la fecha actual
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Convertir la fecha ingresada en el formulario a DateTime
    final selectedDate = DateTime.tryParse(dateController.text);

    // Validar que la fecha seleccionada no sea anterior a la fecha actual
    if (selectedDate == null || selectedDate.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No se puede reservar para una fecha pasada')),
      );
      return;
    }

    const timePattern = r'^\d{2}:\d{2}$';
    final timeRegex = RegExp(timePattern);
    if (!timeRegex.hasMatch(startTimeController.text) ||
        !timeRegex.hasMatch(endTimeController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, ingrese una hora válida (HH:MM)')),
      );
      return;
    }

    // Convertir las horas a DateTime para validarlas
    final startTimeParts = startTimeController.text.split(':');
    final endTimeParts = endTimeController.text.split(':');

    final startTime = DateTime(today.year, today.month, today.day,
        int.parse(startTimeParts[0]), int.parse(startTimeParts[1]));
    final endTime = DateTime(today.year, today.month, today.day,
        int.parse(endTimeParts[0]), int.parse(endTimeParts[1]));

    // Validar que la hora de inicio es antes que la hora de fin
    if (startTime.isAfter(endTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('La hora de inicio debe ser antes de la hora de fin')),
      );
      return;
    }

    final date = dateController.text;
    final courtBloc = BlocProvider.of<CourtOneBloc>(context);
    courtBloc.add(CourtOneEventRequested(id));
    courtBloc.stream.listen((state) {
      if (state is CourtOneSuccess) {}
    });

    // Aquí puedes manejar la lógica de envío del formulario
    // Por ejemplo, enviar los datos a un servidor o almacenarlos localmente
  }
}
