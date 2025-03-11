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
}
