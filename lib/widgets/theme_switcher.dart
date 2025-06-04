// lib/widgets/theme_switcher.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme/theme_cubit.dart';
import '../bloc/theme/theme_state.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return PopupMenuButton<String>(
          icon: Icon(
            _getThemeIcon(state.themeMode),
            color: Theme.of(context).iconTheme.color,
          ),
          tooltip: 'Cambiar tema',
          onSelected: (String value) {
            final themeCubit = context.read<ThemeCubit>();
            switch (value) {
              case 'light':
                themeCubit.setLightTheme();
                break;
              case 'dark':
                themeCubit.setDarkTheme();
                break;
              case 'system':
                themeCubit.setSystemTheme();
                break;
            }
          },
          itemBuilder:
              (context) => [
                _buildPopupMenuItem(
                  'light',
                  'Tema Claro',
                  Icons.light_mode,
                  Colors.orange,
                  state.themeMode == ThemeMode.light,
                ),
                _buildPopupMenuItem(
                  'dark',
                  'Tema Oscuro',
                  Icons.dark_mode,
                  Colors.indigo,
                  state.themeMode == ThemeMode.dark,
                ),
                _buildPopupMenuItem(
                  'system',
                  'Automático',
                  Icons.settings_suggest,
                  Colors.grey,
                  state.themeMode == ThemeMode.system,
                ),
              ],
        );
      },
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    String value,
    String title,
    IconData icon,
    Color iconColor,
    bool isSelected,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(child: Text(title)),
          if (isSelected) const Icon(Icons.check, color: Colors.green),
        ],
      ),
    );
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_suggest;
    }
  }
}

// Widget simple para alternar tema (botón flotante)
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
          tooltip:
              state.isDarkMode
                  ? 'Cambiar a tema claro'
                  : 'Cambiar a tema oscuro',
          child: Icon(state.isDarkMode ? Icons.light_mode : Icons.dark_mode),
        );
      },
    );
  }
}

// Widget de configuración de tema (para páginas de configuración)
class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Apariencia',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _buildThemeOption(
                  context,
                  'Claro',
                  'Usar tema claro siempre',
                  Icons.light_mode,
                  ThemeMode.light,
                  state.themeMode,
                ),
                _buildThemeOption(
                  context,
                  'Oscuro',
                  'Usar tema oscuro siempre',
                  Icons.dark_mode,
                  ThemeMode.dark,
                  state.themeMode,
                ),
                _buildThemeOption(
                  context,
                  'Automático',
                  'Seguir configuración del sistema',
                  Icons.settings_suggest,
                  ThemeMode.system,
                  state.themeMode,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    ThemeMode themeMode,
    ThemeMode currentMode,
  ) {
    final isSelected = currentMode == themeMode;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing:
          isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        final themeCubit = context.read<ThemeCubit>();
        switch (themeMode) {
          case ThemeMode.light:
            themeCubit.setLightTheme();
            break;
          case ThemeMode.dark:
            themeCubit.setDarkTheme();
            break;
          case ThemeMode.system:
            themeCubit.setSystemTheme();
            break;
        }
      },
    );
  }
}
