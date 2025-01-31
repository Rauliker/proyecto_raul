import 'dart:ui';

import 'package:bidhub/presentations/bloc/language/language_event.dart';
import 'package:bidhub/presentations/bloc/language/language_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('es'))) {
    on<ChangeLanguageEvent>((event, emit) {
      emit(LanguageState(event.locale));
    });
  }
}
