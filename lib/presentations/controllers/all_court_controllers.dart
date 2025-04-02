import 'package:bidhub/presentations/bloc/getCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_event.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_status.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_event.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class AllCourtController {
  final BuildContext context;
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  String? selectedCourtType = 'Todos';

  AllCourtController(this.context);

  void initialize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCourtTypeData();
      _fetchCourtData();
    });
  }

  void _fetchCourtTypeData() {
    final courtTypeBloc = context.read<CourtTypeBloc>();
    if (!courtTypeBloc.isClosed) {
      courtTypeBloc.add(const CourtTypeEventRequested());
    } else {
      context.read<CourtTypeBloc>().add(const CourtTypeEventRequested());
    }
  }

  void _fetchCourtData({int? idType}) {
    final courtBloc = context.read<CourtBloc>();
    if (!courtBloc.isClosed) {
      courtBloc.add(CourtEventRequested(idType));
    } else {
      context.read<CourtBloc>().add(CourtEventRequested(idType));
    }
  }

  List<DropdownMenuItem<String>> buildDropdownItems(CourtTypeSuccess state) {
    return ['Todos', ...state.courtType.map((courtType) => courtType.name)]
        .map((courtType) {
      return DropdownMenuItem<String>(
        value: courtType,
        child: Row(
          children: [
            const SizedBox(width: 10),
            Text(courtType),
          ],
        ),
      );
    }).toList();
  }

  void onCourtTypeChanged(String? value) {
    if (value != null) {
      selectedCourtType = value;
      if (value == 'Todos') {
        _fetchCourtData();
      } else {
        final state = context.read<CourtTypeBloc>().state;
        if (state is CourtTypeSuccess) {
          final selectedType = state.courtType
              .firstWhereOrNull((element) => element.name == value);
          _fetchCourtData(idType: selectedType?.id);
        }
      }
    }
  }

  List<BlocListener> buildBlocListeners() {
    return [
      BlocListener<CourtTypeBloc, CourtTypeState>(
        listener: (context, state) {
          if (state is CourtTypeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
      BlocListener<CourtBloc, CourtState>(
        listener: (context, state) {
          if (state is CourtFailure) {
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
