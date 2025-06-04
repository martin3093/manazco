// lib/bloc/theme/theme_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final bool isDarkMode;
  final String themeName;

  const ThemeState({
    required this.themeMode,
    required this.isDarkMode,
    required this.themeName,
  });

  // Estado inicial
  factory ThemeState.initial() {
    return const ThemeState(
      themeMode: ThemeMode.system,
      isDarkMode: false,
      themeName: 'Sistema',
    );
  }

  // Método para crear una copia con cambios
  ThemeState copyWith({
    ThemeMode? themeMode,
    bool? isDarkMode,
    String? themeName,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeName: themeName ?? this.themeName,
    );
  }

  @override
  List<Object> get props => [themeMode, isDarkMode, themeName];
}
