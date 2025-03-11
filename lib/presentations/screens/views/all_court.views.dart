import 'package:bidhub/presentations/bloc/getCourt/get_court_bloc.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_event.dart';
import 'package:bidhub/presentations/bloc/getCourt/get_court_status.dart';
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
  String? _selectedCourtType;

  @override
  void initState() {
    super.initState();
    _fetchCourtTypeData();
    _fetchCourtData();
    _selectedCourtType = 'Todos';
  }

  void _fetchCourtTypeData() {
    BlocProvider.of<CourtTypeBloc>(context)
        .add(const CourtTypeEventRequested());
  }

  void _fetchCourtData() {
    BlocProvider.of<CourtBloc>(context).add(const CourtEventRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explora", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: MultiBlocListener(
        listeners: [
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
        ],
        child: Column(
          children: [
            BlocBuilder<CourtTypeBloc, CourtTypeState>(
              builder: (context, state) {
                if (state is CourtTypeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CourtTypeSuccess) {
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
                } else if (state is CourtTypeFailure) {
                  return Center(child: Text(state.message));
                }
                return const Center(
                    child: Text("No hay tipos de pistas disponibles"));
              },
            ),
            Expanded(
              child: BlocBuilder<CourtBloc, CourtState>(
                builder: (context, state) {
                  if (state is CourtLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CourtSuccess) {
                    return ListView.builder(
                      itemCount: state.court.length,
                      itemBuilder: (context, index) {
                        final court = state.court[index];
                        return ListTile(
                          leading: Image.network(
                            court.imageUrl != null
                                ? "$_baseUrl${court.imageUrl}"
                                : 'assets/hero_onboarding.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          title: Text(court.name),
                        );
                      },
                    );
                  } else if (state is CourtFailure) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("No hay pistas disponibles"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
