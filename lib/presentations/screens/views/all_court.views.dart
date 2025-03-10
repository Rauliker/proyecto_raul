import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_event.dart';
import 'package:bidhub/presentations/bloc/getCourtType/get_all_court_type_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AllCourtView extends StatefulWidget {
  const AllCourtView({super.key});

  @override
  State<AllCourtView> createState() => _AllCourtViewState();
}

class _AllCourtViewState extends State<AllCourtView> {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';

  @override
  void initState() {
    super.initState();
    _fetchCourtTypeData();
  }

  void _fetchCourtTypeData() {
    BlocProvider.of<CourtTypeBloc>(context)
        .add(const CourtTypeEventRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pistas")),
      body: BlocBuilder<CourtTypeBloc, CourtTypeState>(
        builder: (context, state) {
          if (state is CourtTypeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourtTypeSuccess) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                final court = state.courtType;

                return ListTile(
                  leading: const Icon(Icons.sports_tennis),
                  title: Text(court.name),
                );
              },
            );
          } else if (state is CourtTypeFailure) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("No hay pistas disponibles"));
        },
      ),
    );
  }
}
