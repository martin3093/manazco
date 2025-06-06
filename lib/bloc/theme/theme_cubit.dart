// lib/bloc/theme/theme_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manazco/bloc/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'selected_theme';
  static const String _customColorKey = 'custom_primary_color';

  ThemeCubit() : super(ThemeState.initial()) {
    _loadSavedTheme();
  }

  // Cargar tema guardado al iniciar la aplicación
  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      if (savedTheme != null) {
        switch (savedTheme) {
          case 'light':
            _emitThemeState(ThemeMode.light, false, 'Claro');
            break;
          case 'dark':
            _emitThemeState(ThemeMode.dark, true, 'Oscuro');
            break;
          case 'system':
          default:
            _emitThemeState(ThemeMode.system, false, 'Sistema');
            break;
        }
      }
    } catch (e) {
      // Si hay error, mantener el tema por defecto
      debugPrint('Error al cargar tema: $e');
    }
  }

  // Cambiar a tema claro
  Future<void> setLightTheme() async {
    await _saveTheme('light');
    _emitThemeState(ThemeMode.light, false, 'Claro');
  }

  // Cambiar a tema oscuro
  Future<void> setDarkTheme() async {
    await _saveTheme('dark');
    _emitThemeState(ThemeMode.dark, true, 'Oscuro');
  }

  // Cambiar a tema del sistema
  Future<void> setSystemTheme() async {
    await _saveTheme('system');
    _emitThemeState(ThemeMode.system, false, 'Sistema');
  }

  // Alternar entre temas claro y oscuro
  Future<void> toggleTheme() async {
    if (state.themeMode == ThemeMode.dark) {
      await setLightTheme();
    } else {
      await setDarkTheme();
    }
  }

  // Detectar si el sistema está en modo oscuro
  void updateSystemTheme(bool isSystemDark) {
    if (state.themeMode == ThemeMode.system) {
      emit(state.copyWith(isDarkMode: isSystemDark));
    }
  }

  // Métodos privados
  Future<void> _saveTheme(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, theme);
    } catch (e) {
      debugPrint('Error al guardar tema: $e');
    }
  }

  void _emitThemeState(ThemeMode mode, bool isDark, String name) {
    emit(state.copyWith(themeMode: mode, isDarkMode: isDark, themeName: name));
  }

  // Método para obtener el tema actual como string
  String get currentThemeString {
    switch (state.themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  // Verificar si es tema oscuro actualmente
  bool get isCurrentlyDark {
    return state.isDarkMode;
  }
}
