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
  String? _selectedCourtType; // Store the selected court type

  @override
  void initState() {
    super.initState();
    _fetchCourtTypeData();
    // Set default value to show all court types at the beginning
    _selectedCourtType = 'Todos'; // Default value for "All"
  }

  void _fetchCourtTypeData() {
    BlocProvider.of<CourtTypeBloc>(context)
        .add(const CourtTypeEventRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explora", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: BlocBuilder<CourtTypeBloc, CourtTypeState>(
        builder: (context, state) {
          if (state is CourtTypeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CourtTypeSuccess) {
            return ListView.builder(
              itemCount: state.courtType.length + 1, // Include one for "Todos"
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Row(
                    children: [
                      Text(
                        _selectedCourtType != null
                            ? "$_selectedCourtType"
                            : "Todos",
                        style: const TextStyle(color: Colors.orange),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        hint: const Text("Selecciona el tipo de pista"),
                        value: _selectedCourtType,
                        items: [
                          'Todos',
                          ...state.courtType.map((courtType) => courtType.name)
                        ].map((courtType) {
                          return DropdownMenuItem<String>(
                            value: courtType,
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Text(courtType),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCourtType = value;
                          });
                        },
                      ),
                    ],
                  );
                } else {
                  final court = state.courtType[index - 1];
                  return ListTile(
                    leading: const Icon(Icons.sports_tennis),
                    title: Text(court.name),
                  );
                }
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
