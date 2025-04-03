import 'package:bidhub/core/themes/custom_snackbar_theme.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_event.dart';
import 'package:bidhub/presentations/bloc/getOneCourt/get_one_court_status.dart';
import 'package:bidhub/presentations/bloc/reservation/reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/reservation/reservation_event.dart';
import 'package:bidhub/presentations/bloc/reservation/reservation_state.dart';
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

  bool hasToken = true;

  void initialize() {
    selectedCourtType = 'Todos';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCourtData(id);
    });

    // Establecer la fecha actual por defecto
    final now = DateTime.now();
    dateController.text =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    // Establecer la hora de inicio y fin con la hora actual, pero con un incremento de 1 hora para la hora de inicio
    startTimeController.text =
        "${now.hour.toString().padLeft(2, '0')}:${(now.minute ~/ 15 * 15).toString().padLeft(2, '0')}";
    endTimeController.text =
        "${(now.hour + 1).toString().padLeft(2, '0')}:${(now.minute ~/ 15 * 15).toString().padLeft(2, '0')}";
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

  // Método para incrementar o decrementar la hora
  void incrementHour(TextEditingController controller) {
    final currentTime = TimeOfDay.fromDateTime(
        DateTime.parse('1970-01-01 ${controller.text}:00'));
    final incrementedTime = currentTime.replacing(hour: currentTime.hour + 1);
    controller.text =
        "${incrementedTime.hour.toString().padLeft(2, '0')}:${incrementedTime.minute.toString().padLeft(2, '0')}";
  }

  void decrementHour(TextEditingController controller) {
    final currentTime = TimeOfDay.fromDateTime(
        DateTime.parse('1970-01-01 ${controller.text}:00'));
    final decrementedTime = currentTime.replacing(hour: currentTime.hour - 1);
    controller.text =
        "${decrementedTime.hour.toString().padLeft(2, '0')}:${decrementedTime.minute.toString().padLeft(2, '0')}";
  }

  // Método para incrementar o decrementar los minutos
  void incrementMinutes(TextEditingController controller) {
    final currentTime = TimeOfDay.fromDateTime(
        DateTime.parse('1970-01-01 ${controller.text}:00'));
    final incrementedTime =
        currentTime.replacing(minute: (currentTime.minute + 15) % 60);
    controller.text =
        "${incrementedTime.hour.toString().padLeft(2, '0')}:${incrementedTime.minute.toString().padLeft(2, '0')}";
  }

  void decrementMinutes(TextEditingController controller) {
    final currentTime = TimeOfDay.fromDateTime(
        DateTime.parse('1970-01-01 ${controller.text}:00'));
    final decrementedTime =
        currentTime.replacing(minute: (currentTime.minute - 15 + 60) % 60);
    controller.text =
        "${decrementedTime.hour.toString().padLeft(2, '0')}:${decrementedTime.minute.toString().padLeft(2, '0')}";
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

    final startTimeVal = DateTime(today.month, today.day,
        int.parse(startTimeParts[0]), int.parse(startTimeParts[1]));
    final endTimeVal = DateTime(today.year, today.month, today.day,
        int.parse(endTimeParts[0]), int.parse(endTimeParts[1]));

    final startTime = DateTime(today.year, today.month, today.day,
        int.parse(startTimeParts[0]), int.parse(startTimeParts[1]));
    final endTime = DateTime(today.year, today.month, today.day,
        int.parse(endTimeParts[0]), int.parse(endTimeParts[1]));

    String formattedStartTime =
        "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";
    String formattedEndTime =
        "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";

    // Validar que la hora de inicio es antes que la hora de fin
    if (startTimeVal.isAfter(endTimeVal)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('La hora de inicio debe ser antes de la hora de fin')),
      );
      return;
    }
    final date = dateController.text;
    final courtBloc = BlocProvider.of<ReservationBloc>(context);
    courtBloc.add(ReservationCreate(
      id: id,
      data: date,
      startTime: formattedStartTime,
      endTime: formattedEndTime,
    ));

    int i = 0;
    courtBloc.stream.listen((state) {
      if (state is ReservationFailure) {
        if (i == 0) {
          CustomSnackbar.failedSnackbar(
            title: 'Failed',
            message: state.message.replaceAll('Exception: ', ''),
          );
        }

        return;
      } else if (state is ReservationSuccess) {
        if (i == 0) {
          CustomSnackbar.successSnackbar(
            title: 'Success',
            message: state.message,
          );
        }
        return;
      }
    });
  }

  Future<void> fetchDataForm({required String data}) async {
    final timeRange = data.split('-');
    if (timeRange.length == 2) {
      startTimeController.text = timeRange[0].trim();
      endTimeController.text = timeRange[1].trim();
    }
  }
}
