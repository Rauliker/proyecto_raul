import 'package:bidhub/core/themes/custom_snackbar_theme.dart';
import 'package:bidhub/presentations/bloc/cancelReservation/cancel_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/cancelReservation/cancel_reservation_event.dart';
import 'package:bidhub/presentations/bloc/cancelReservation/cancel_reservation_state.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/get_all_aeservation_event.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/get_all_reservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/get_all_reservation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationController {
  var hasToken = true.obs;
  final BuildContext context;
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  String? selectedCourtType;

  ReservationController(this.context);

  void initialize(String type) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchGetAllReservation(type);
    });
    _checkToken();
  }

  int calculatePrice(int price, String startTime, String endTime) {
    final start = TimeOfDay(
      hour: int.parse(startTime.split(":")[0]),
      minute: int.parse(startTime.split(":")[1]),
    );
    final end = TimeOfDay(
      hour: int.parse(endTime.split(":")[0]),
      minute: int.parse(endTime.split(":")[1]),
    );

    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final durationMinutes = endMinutes - startMinutes;

    final durationHours = durationMinutes / 60;
    return (price * durationHours).ceil();
  }

  Future<void> _checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    hasToken.value = token != null && token.isNotEmpty;
  }

  void _fetchGetAllReservation(String type) {
    if (type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tipo de reserva no válido")),
      );
      return;
    }

    final bloc = context.read<GetAllReservationBloc>();
    if (!bloc.isClosed) {
      bloc.add(GetAllReservationCreate(type: type));
    } else {
      context
          .read<GetAllReservationBloc>()
          .add(GetAllReservationCreate(type: type));
    }
  }

  List<BlocListener> buildBlocListeners() {
    return [
      BlocListener<GetAllReservationBloc, GetAllReservationState>(
        listener: (context, state) {
          if (state is GetAllReservationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    ];
  }

  void delete(BuildContext context, int id) {
    final userBloc = BlocProvider.of<CancelReservationBloc>(context);
    userBloc.add(CancelReservationCreate(id: id));
    userBloc.stream.listen((state) {
      if (state is CancelReservationFailure) {
        CustomSnackbar.failedSnackbar(
          title: 'Failed',
          message: 'Error al cancelar',
        );
        return;
      } else if (state is CancelReservationSuccess) {
        CustomSnackbar.successSnackbar(
          title: 'Success',
          message: 'Reserva cancelada correctamente',
        );
        _fetchGetAllReservation("actives");
        return;
      }
    });
  }

  String getCourtImageUrl(String? imageUrl) {
    return imageUrl != null
        ? Uri.parse("$_baseUrl$imageUrl").toString()
        : 'assets/hero_onboarding.png';
  }
}
