import 'package:bidhub/presentations/bloc/getAllReservation/getAllReservation_bloc.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/getAllReservation_event.dart';
import 'package:bidhub/presentations/bloc/getAllReservation/getAllReservation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReservationController {
  final BuildContext context;
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  String? selectedCourtType;

  ReservationController(this.context);

  void initialize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchGetAllReservation();
    });
  }

  void _fetchGetAllReservation() {
    context
        .read<GetAllReservationBloc>()
        .add(const GetAllReservationCreate(type: "actives"));
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

  String getCourtImageUrl(String? imageUrl) {
    return imageUrl != null
        ? Uri.parse("$_baseUrl$imageUrl").toString()
        : 'assets/hero_onboarding.png';
  }
}
