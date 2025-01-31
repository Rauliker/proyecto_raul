import 'package:bidhub/domain/usercase/prov_usercase.dart';
import 'package:bidhub/presentations/bloc/provincias/prov_event.dart';
import 'package:bidhub/presentations/bloc/provincias/prov_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProvBloc extends Bloc<ProvEvent, ProvState> {
  final CaseProvInfo provInfo;

  ProvBloc(this.provInfo) : super(ProvInitial()) {
    on<ProvDataRequest>((event, emit) async {
      emit(ProvLoading());
      try {
        final prov = await provInfo();
        emit(ProvLoaded(prov));
      } catch (e) {
        emit(ProvError(message: e.toString()));
      }
    });
  }
}
