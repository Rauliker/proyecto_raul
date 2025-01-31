import 'package:bidhub/config/theme/theme.dart';

class ThemeState {
  final AppTheme currentTheme;
  final AppTheme? temporalTheme;

  ThemeState({
    required this.currentTheme,
    this.temporalTheme,
  });
}
